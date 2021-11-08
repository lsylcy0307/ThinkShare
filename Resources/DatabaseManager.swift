//
//  DatabaseManager.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/06/13.
//

import Foundation
import FirebaseFirestore
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    private let firestore = Firestore.firestore()
    private let database = Database.database().reference()
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager{
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
        
    }
    
    public func isTeacher(with email: String,
                          completion: @escaping ((Bool) -> Void)) {
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard let user = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            guard let identity = user["identity"] as? String else{
                return
            }
            print("the user is \(identity)")
            if identity == "Teacher" {
                completion(true)
            }
            else{
                completion(false)
            }
        })
        
    }
    
    /// Inserts new user to database
    public func insertUser(with user: HarknessAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "identity":user.identity
        ], withCompletionBlock: { [weak self] error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }
            
            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail,
                        "identity": user.identity
                    ]
                    usersCollection.append(newElement)
                    
                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
                else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail,
                            "identity": user.identity
                            //CHECK THE CLASS
                        ]
                    ]
                    
                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
            })
        })
    }
    
    
    //code registered - code, teacher name, texts
    
    public func codeRegistered(with code: String,
                               completion: @escaping ((Bool) -> Void)) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child("\(safeEmail)/registeredSettings").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            // iterate and find conversation with target sender
            if let setting = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return code == targetCode
            }) {
                // get id
                guard let selectedCode = setting["code"] as? String else {
                    print("failed getting the variables")
                    return
                }
                print(selectedCode)
                completion(true)
                return
            }
            completion(false)
            return
        })
    }
    
    public func findUserWithCode(with code: String, completion: @escaping (Bool) -> Void){
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let usersCollection = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            for user in usersCollection{
                guard let identity = user["identity"] as? String,
                      let name = user["name"] as? String,
                      let email = user["email"] as? String else{
                          return
                      }
                if identity == "Teacher" {
                    print("teacher")
                    guard let settings = user["registeredSettings"] as? [[String:String]] else{
                        return
                    }
                    for setting in settings {
                        if setting["code"]==code{
                            print("this user has the code: \(name)")
                            self.registerCode(with: code, name: name, email: email, completion: completion)
                            completion(true)
                            return
                        }
                    }
                }
            }
            completion(false)
            return
        })
    }
    
    private func registerCode(with code: String, name: String, email: String, completion: @escaping (Bool) -> Void) {
        guard let userEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeUserEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        let ref = database.child("\(safeUserEmail)")
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let newData: [String:Any] = [
                "code":code,
                "email":email,
                "name":name
            ]
            
            if var registeredCodes = userNode["registeredSettings"] as? [[String:Any]] {
                //conversation array exists for current  user
                //append
                registeredCodes.append(newData)
                userNode["registeredSettings"] = registeredCodes
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                })
            }
            else{
                //conversation array does not exist create
                userNode["registeredSettings"] = [
                    newData
                ]
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                })
            }
            completion(true)
        })
    }
    
    
    public func addDiscussionSetting(with data:[discussionSetting], completion: @escaping (Bool) -> Void){
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        let randomString = UUID().uuidString.uppercased()
        let code = randomString.prefix(7)
        let safeUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        let ref = database.child("\(safeUserEmail)")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let date = Date()
            let dateString = CreateDiscussionViewController.dateFormatter.string(from: date)
            if var discussionSettings = userNode["discussionSettings"] as? [[String:Any]]{
                
                //conversation array exists for current  user
                //append
                var discussionSetting = [[String:Any]]()
                for setting in data {
                    let newSettingData: [String:Any] =
                    ["textName":setting.textName,
                     "textLink":setting.textLink,
                     "questions": setting.questions]
                    discussionSetting.append(newSettingData)
                }
                let dataWithCode = ["code":code, "registeredDate":dateString, "texts": discussionSetting] as [String : Any]
                discussionSettings.append(dataWithCode)
                
                userNode["discussionSettings"] = discussionSettings
                ref.setValue(userNode, withCompletionBlock: {[weak self] error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    self?.finishCreatingSetting(with: safeUserEmail, data: dataWithCode, completion: completion)
                    print("finishcreating")
                })
            }
            else{
                print("creating new")
                //discussionSettings array does not exist create
                var discussionSettingData = [[String:Any]]()
                for setting in data {
                    let newSettingData: [String:Any] =
                    ["textName":setting.textName,
                     "textLink":setting.textLink,
                     "questions": setting.questions]
                    discussionSettingData.append(newSettingData)
                }
                let dataWithCode = ["code":code,"registeredDate":dateString, "texts": discussionSettingData] as [String : Any]
                
                userNode["discussionSettings"] = [dataWithCode]
                
                ref.setValue(userNode, withCompletionBlock: {[weak self] error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    self?.finishCreatingSetting(with: safeUserEmail, data: dataWithCode, completion: completion)
                    print("finishcreating")
                })
            }
            completion(true)
        })
    }
    
    private func finishCreatingSetting(with targetUserEmail: String, data:[String : Any], completion:  @escaping (Bool) -> Void){
        print("sending...")
        let code = data["code"]
        let dataToSend = ["code":code]
        database.child("users").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var collection = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            print(collection)
            
            // iterate and find conversation with target sender
            var cnt = 0
            if var user = collection.first(where: {
                guard let targetEmail = $0["email"] as? String else {
                    return false
                }
                cnt+=1
                return targetEmail == targetUserEmail
            }) {
                print(cnt)
                if var settings = user["registeredSettings"] as? [[String:Any]]{
                    settings.append(dataToSend as [String : Any])
                    print("----")
                    user["registeredSettings"] = settings
                    collection[cnt-1] = user
                    self?.database.child("users").setValue(collection, withCompletionBlock: { error,_  in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                    })
                }
                else{
                    print("creating new")
                    var discussionSettingData = [[String:Any]]()
                    discussionSettingData.append(dataToSend as [String : Any])
                    user["registeredSettings"] = discussionSettingData
                    collection[cnt-1] = user
                    self?.database.child("users").setValue(collection, withCompletionBlock: {error,_  in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                    })
                }
                completion(true)
            }
        })
    }
    
    public func loadSettings(with setting: registeredSetting, completion: @escaping (Result<[[String:Any]], Error>) -> Void){
        
        let ref = database.child("\(setting.teacherEmail)/discussionSettings")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            // iterate and find conversation with target sender
            if let discussionSetting = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return setting.code == targetCode
            }) {
                guard let texts = discussionSetting["texts"] as? [[String:Any]] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                completion(.success(texts))
                return
            }
            
        })
        
    }
    
    public func createNewDiscussionGroup(with setting_code: String, teacherName: String, teacherEmail: String, num_students: Int, groupName: String, tableSetting:[Int], nameSetting:[String],completion: @escaping (Result<String, Error>) -> Void){
        print("registering...")
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let currentDatetime = Date()
        let usercalendar = Calendar.current
        let requestComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        
        let dateTimeComponents = usercalendar.dateComponents(requestComponents, from: currentDatetime)
        
        guard let year = dateTimeComponents.year,
              let month = dateTimeComponents.month,
              let day = dateTimeComponents.day else{
                  return
              }
        
        let date = "\(year)-\(month)-\(day)"
        print(date)
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let randomString = UUID().uuidString.uppercased()
            let code = randomString.prefix(6)
            let discussionId = "discussion_\(safeEmail)_\(code)"
            
            let newDiscussionData: [String: Any] = [
                "id": discussionId,
                "date":date,
                "setting_code": setting_code,
                "teacher_email": teacherEmail,
                "teacherName": teacherName,
                "group_name": groupName,
                "discussion_setup": [
                    "num_students": num_students,
                    "table_setting" : tableSetting,
                    "name_setting" : nameSetting
                ]
            ]
            
            // Update current user discussion entry
            if var discussions = userNode["discussions"] as? [[String: Any]] {
                // discussion array exists for current user
                // you should append
                discussions.append(newDiscussionData)
                userNode["discussions"] = discussions
                ref.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    //return discussionId
                    completion(.success(discussionId))
                })
            }
            else {
                // discussion array does NOT exist
                // create it
                userNode["discussions"] = [
                    newDiscussionData
                ]
                
                ref.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    //return discussionId
                    completion(.success(discussionId))
                    
                })
            }
        })
        
    }
    
    public func finishCreatingDiscussion(discussionID: String, registeredQs:[String], completion: @escaping (Bool) -> Void) {
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        
        let value: [String: Any] = [
            "user_email": currentUserEmail,
            "is_completed": false,
            "student_questions":registeredQs
        ]
        
        print("adding discussion: \(discussionID)")
        
        database.child("\(discussionID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    public func getAllDiscussionSettings(for email: String, completion: @escaping (Result<[Setting], Error>) -> Void) {
        database.child("\(email)/discussionSettings").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let settings: [Setting] = value.compactMap({ dictionary in
                guard let code = dictionary["code"] as? String,
                      let texts = dictionary["texts"] as? [[String:Any]],
                      let date = dictionary["registeredDate"] as? String else {
                          print("nil")
                          return nil
                      }
                var settings = [discussionSetting]()
                for text in texts {
                    guard let questions = text["questions"] as? [String],
                          let textLink = text["textLink"] as? String,
                          let textName = text["textName"] as? String else{
                              return nil
                          }
                    settings.append(discussionSetting(textName: textName, textLink: textLink, questions: questions))
                }
                print("ready to send")
                print(settings)
                
                return Setting(code: code, textSettings: settings, registeredDate: date)
            })
            
            completion(.success(settings))
        })
    }
    
    
    public func recordDiscussionResult(with discussionId:String, speakFrequency: [Int], speakTime: [Int], usedQuestions:[String], initialTime: Int, finishTime:Int, responseTypeCnt:[Int], completion: @escaping (Bool) -> Void){
        
        let start_Time = timerFormat(seconds: initialTime)
        let startTimeString = makeTimeString(minutes: start_Time.0, seconds: start_Time.1)
        
        let end_Time = timerFormat(seconds: finishTime)
        let endTimeString = makeTimeString(minutes: end_Time.0, seconds: end_Time.1)
        
        let ref = database.child("\(discussionId)")
        ref.child("is_completed").setValue(true)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("discussion not found")
                return
            }
            
            let discussionResult: [String: Any] = [
                "FrequencyDistribution": speakFrequency,
                "startTime": startTimeString,
                "finishTime": endTimeString,
                "startTime_int":initialTime,
                "endTime_int":finishTime,
                "SpeakTimeDistribution": speakTime,
                "UsedQuestions": usedQuestions,
                "responseTypeCnt": responseTypeCnt
            ]
            
            if var result = userNode["discussionResult"] as? [[String:Any]]{
                
                result.append(discussionResult)
                
                userNode["discussionResult"] = result
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                })
            }
            else{
                print("creating new")
                userNode["discussionResult"] = discussionResult
                
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    print("first time recording result")
                })
            }
            completion(true)
        })
    }
    
    public func recordDiscussionFlow(with discussionId:String, selectedPerson: String, startTime: Int, endTime: Int, duration: Int, responseType:[String], responseAList:[String],responseBList:[String], completion: @escaping (Bool) -> Void){
        
        let start_Time = timerFormat(seconds: startTime)
        let startTimeString = makeTimeString(minutes: start_Time.0, seconds: start_Time.1)
        
        let end_Time = timerFormat(seconds: endTime)
        let endTimeString = makeTimeString(minutes: end_Time.0, seconds: end_Time.1)
        
        let dur_Time = timerFormat(seconds: duration)
        let durTimeString = makeTimeString(minutes: dur_Time.0, seconds: dur_Time.1)
        let ref = database.child("\(discussionId)")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("discussion not found")
                return
            }
            
            let newFlowEntry: [String: Any] = [
                "name": selectedPerson,
                "startTime": startTimeString,
                "endTime": endTimeString,
                "duration": durTimeString,
                "responseType":responseType,
                "react_pressed_x":responseAList,
                "react_thumbs_ups":responseBList
            ]
            
            if var discussionFlows = userNode["discussionFlow"] as? [[String:Any]]{
                
                //flow array exists for current  user
                //append
                discussionFlows.append(newFlowEntry)
                
                userNode["discussionFlow"] = discussionFlows
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                })
            }
            else{
                print("creating new")
                //discussionFlow array does not exist create
                userNode["discussionFlow"] = [newFlowEntry]
                
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    print("first time recording flow")
                })
            }
            completion(true)
        })
    }
    
    public func getDiscussionSettings(with email:String, discussionID: String, completion: @escaping (Result<Setup, Error>) -> Void){
        
        database.child("\(email)/discussions").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            if let setting = collection.first(where: {
                guard let targetID = $0["id"] as? String else {
                    return false
                }
                return discussionID == targetID
            }) {
                print(setting)
                guard let groupName = setting["group_name"] as? String,
                      let date = setting["date"] as? String ,
                      let settingCode = setting["setting_code"] as? String ,
                      let teacherName = setting["teacherName"] as? String,
                      let discussionSetting = setting["discussion_setup"] as? [String:Any]
                else {
                    print("could not fetch the setting")
                    return
                }
                //                print(discussionSetting)
                let setup = Setup(date: date, groupName: groupName, id: discussionID, settingCode: settingCode, teacherName: teacherName, names: discussionSetting["name_setting"] as! [String], numParticipants: discussionSetting["num_students"] as! Int, tableSetting: discussionSetting["table_setting"] as! [Int])
                completion(.success(setup))
                return
            }
            
        })
        
    }
    
    public func getDiscussionFlow(with discussionId:String, completion: @escaping (Result<[flow], Error>) -> Void){
        
        database.child("\(discussionId)/discussionFlow").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let flows: [flow] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                      let endTime = dictionary["endTime"] as? String,
                      let duration = dictionary["duration"] as? String,
                      let startTime = dictionary["startTime"] as? String,
                      let responseType = dictionary["responseType"] as? [String] else {
                          return nil
                      }
                return flow(name: name, duration: duration, endTime: endTime, responseType: responseType, startTime: startTime)
            })
            completion(.success(flows))
        })
        
    }
    
    public func getDiscussionResult(with discussionId:String, completion: @escaping (Result<DiscResult, Error>) -> Void){
        
        database.child("\(discussionId)/discussionResult").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            //            print(value)
            
            guard let fdist = value["FrequencyDistribution"] as? [Int],
                  let sdist = value["SpeakTimeDistribution"] as? [Int],
                  let questions = value["UsedQuestions"] as? [String],
                  let finishTime = value["endTime_int"] as? Int,
                  let startTime = value["startTime_int"] as? Int,
                  let responseTypeCnt = value["responseTypeCnt"] as? [Int]
            else {
                return
            }
            
            let result = DiscResult(FrequencyDistribution: fdist, SpeakTimeDistribution: sdist, finishTime: finishTime, startTime: startTime, UsedQuestions: questions, responseTypeCnt: responseTypeCnt)
            
            completion(.success(result))
        })
        
    }
    
    public func getAllDiscussionHistory(for email: String, completion: @escaping (Result<[discussionHistory], Error>) -> Void) {
        database.child("\(email)/discussions").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let settings: [discussionHistory] = value.compactMap({ dictionary in
                guard let name = dictionary["group_name"] as? String,
                      let id = dictionary["id"] as? String,
                      let date = dictionary["date"] as? String else {
                          print("!")
                          return nil
                      }
                
                return discussionHistory(code: id, name: name, date: date)
            })
            completion(.success(settings))
        })
    }
    
    public func getAllUserRegisteredSettings(for email: String, completion: @escaping (Result<[registeredSetting], Error>) -> Void) {
        database.child("\(email)/registeredSettings").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let settings: [registeredSetting] = value.compactMap({ dictionary in
                guard let code = dictionary["code"] as? String,
                      let teacherEmail = dictionary["email"] as? String,
                      let teacherName = dictionary["name"] as? String else {
                          print("nil")
                          return nil
                      }
                
                return registeredSetting(code: code, teacherEmail: teacherEmail, teacherName: teacherName)
            })
            
            completion(.success(settings))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
    
    private func timerFormat(seconds: Int) -> (Int, Int){
        return ((seconds/60),(seconds % 60)) //min , seconds
    }
    
    private func makeTimeString(minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    public func deleteDiscussionHistory(discussionId: String, completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "emai") as? String else{
                return
        }
        print("deleting one with id : \(discussionId)")
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let ref = database.child("\(safeEmail)/discussions")
        ref.observeSingleEvent(of: .value) {snapshot in
            if var discussions = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for discussion in discussions {
                    if let id  = discussion["id"] as? String,
                       id == discussionId {
                        print("found convo to delete")
                        break
                    }
                    positionToRemove += 1
                }
                
                discussions.remove(at: positionToRemove)
                ref.setValue(discussions, withCompletionBlock: {error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    print("deleted")
                    completion(true)
                })
            }
        }
    }
}


struct HarknessAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let identity:String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}


