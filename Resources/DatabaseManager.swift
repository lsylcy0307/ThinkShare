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
    
//    public func isTeacher(with email: String,
//                          completion: @escaping ((Bool) -> Void)) {
//        print(email)
//        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
//            guard let user = snapshot.value as? [String: Any] else {
//                completion(false)
//                return
//            }
//
//            guard let identity = user["identity"] as? String else{
//                return
//            }
//            print("the user is \(identity)")
//            if identity == "Teacher" {
//                completion(true)
//            }
//            else{
//                completion(false)
//            }
//        })
//
//    }
    
    public func insertUser(with user: HarknessAppUser, completion: @escaping (Bool) -> Void) {
            database.child(user.safeEmail).setValue([
                "first_name": user.firstName,
                "last_name": user.lastName
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
                    if var usersCollection = snapshot.value as? [[String: Any]] {
                        // append to user dictionary
                        let newElement = [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
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
                        let newCollection: [[String: Any]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail
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
    
    //student var
    public func findUserWithCode(with code: String, classCode:String?, completion: @escaping (Bool) -> Void){
        print(code)
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let usersCollection = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            print(usersCollection)
            for user in usersCollection{
                print(user)
                guard let name = user["name"] as? String,
                      let email = user["email"] as? String
                else{
                    return
                }
                
                guard let settings = user["registeredSettings"] as? [[String:String]] else {
                    continue
                }
                
                for setting in settings {
                    if setting["code"] == code{
                        print("this user has the code: \(name)")
                        self.teacherRegisterCode(with: code, name: name, email: email, classCode: classCode!, completion: completion)
                        completion(true)
                        return
                    }
                }
            }
            completion(false)
            return
        })
    }
    
    //teacher
    private func teacherRegisterCode(with code: String, name: String, email: String, classCode:String, completion: @escaping (Bool) -> Void) {
        guard let userEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("registering")
        let safeUserEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        let ref = database.child("\(safeUserEmail)/classrooms")
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [[String:Any]] else {
                completion(false)
                print("user not found")
                return
            }
            let newData: [String:Any] = [
                "code":code,
                "email":email,
                "name":name
            ]
            var cnt = 0
            if var classroom = userNode.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                cnt+=1
                return targetCode == classCode
            }){
                print(cnt)
                if var settings = classroom["registeredSettings"] as? [[String:Any]]{
                    settings.append(newData as [String : Any])
                    print("----")
                    classroom["registeredSettings"] = settings
                    userNode[cnt-1] = classroom
                    print(userNode)
                    ref.setValue(userNode, withCompletionBlock: { error,_  in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                    })
                }
                else{
                        print("creating new")
                        var discussionSettingData = [[String:Any]]()
                        discussionSettingData.append(newData as [String : Any])
                        classroom["registeredSettings"] = discussionSettingData
                        userNode[cnt-1] = classroom
                        print(userNode)
                        ref.setValue(userNode, withCompletionBlock: {error,_  in
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
    
    //student
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
    
    public func addClassroom(with data:[String], className:String, names:[String], completion: @escaping (Bool) -> Void){
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        let safeUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        let ref = database.child("\(safeUserEmail)")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let randomString = UUID().uuidString.uppercased()
            let code = randomString.prefix(4)
            
            var record = [[String: Any]]()
            for i in 1...names.count{
                let newElement = [
                    "name": names[i-1]
                ]
                record.append(newElement)
            }
            
            if var classrooms = userNode["classrooms"] as? [[String:Any]]{
                
                let data = ["code":code, "class": className, "students":data, "student_record":record] as [String : Any]
                classrooms.append(data)
                
                userNode["classrooms"] = classrooms
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
//                    self?.finishCreatingSetting(with: safeUserEmail, data: , completion: completion)
                    print("finishcreating")
                })
            }
            else{
                print("creating new")
                let data = ["code":code, "class": className, "students":data, "student_record":record] as [String : Any]
                
                userNode["classrooms"] = [data]
                
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
//                    self?.finishCreatingSetting(with: safeUserEmail, data: dataWithCode, completion: completion)
                    print("finishcreating")
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
                     "textLink":"",
                     "questions": setting.questions,
                     "criterias":setting.criteria]
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
                     "questions": setting.questions,
                     "criterias":setting.criteria]
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
    
    public func createNewDiscussionGroup(with setting_code: String, teacherName: String, teacherEmail: String, num_students: Int, groupName: String, tableSetting:[Int], nameSetting:[String], classCode:String?, completion: @escaping (Result<String, Error>) -> Void){
        print("registering...")
//        print(sort)
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
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
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
        
        let ref = database.child("\(safeEmail)/classrooms")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                print("user not found")
                return
            }
            var cnt = 0
            if var classroom = userNode.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                cnt+=1
                return targetCode == classCode
            }){
                if var discussions = classroom["discussions"] as? [[String:Any]]{
                    discussions.append(newDiscussionData as [String : Any])
                    classroom["discussions"] = discussions
                    userNode[cnt-1] = classroom
                    ref.setValue(userNode, withCompletionBlock: { error,_  in
                        guard error == nil else{
                            completion(.failure(DatabaseError.failedToFetch))
                            return
                        }
                    })
                }
                else{
                        var discussionSettingData = [[String:Any]]()
                        discussionSettingData.append(newDiscussionData as [String : Any])
                        classroom["discussions"] = discussionSettingData
                        userNode[cnt-1] = classroom
                        ref.setValue(userNode, withCompletionBlock: {error,_  in
                            guard error == nil else{
                                completion(.failure(DatabaseError.failedToFetch))
                                return
                            }
                        })
                    }
                completion(.success(discussionId))
            }
        })
        
//        if (sort == "s"){
//            let ref = database.child("\(safeEmail)")
//            ref.observeSingleEvent(of: .value, with: { snapshot in
//                guard var userNode = snapshot.value as? [String: Any] else {
//                    completion(.failure(DatabaseError.failedToFetch))
//                    return
//                }
//                if var discussions = userNode["discussions"] as? [[String: Any]] {
//                    discussions.append(newDiscussionData)
//                    userNode["discussions"] = discussions
//                    ref.setValue(userNode, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(.failure(DatabaseError.failedToFetch))
//                            return
//                        }
//                        completion(.success(discussionId))
//                    })
//                }
//                else {
//                    userNode["discussions"] = [
//                        newDiscussionData
//                    ]
//
//                    ref.setValue(userNode, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(.failure(DatabaseError.failedToFetch))
//                            return
//                        }
//                        //return discussionId
//                        completion(.success(discussionId))
//
//                    })
//                }
//            })
//        }
//        else if (sort=="t"){
//
//        }
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
    
    public func addQuestions(discussionID: String, newQs:[String], completion: @escaping (Bool) -> Void) {
        let ref = database.child("\(discussionID)")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("discussion not found")
                return
            }
            print(ref)

            if var questions = userNode["student_questions"] as? [String]{
                for q in newQs{
                    questions.append(q)
                }
                userNode["student_questions"] = questions
                print(userNode)
                ref.setValue(userNode, withCompletionBlock: {error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                })
            }
            else{
                print("making new")
                userNode["student_questions"] = newQs
                print(userNode)
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
                let dateArr = date.components(separatedBy: " ")
                let dateString = dateArr[0] + " " + dateArr[1] + " " + dateArr[2]
                
                var settings = [discussionSetting]()
                for text in texts {
                    guard let questions = text["questions"] as? [String],
                          let criterias = text["criterias"] as? [String],
                          let textLink = text["textLink"] as? String,
                          let textName = text["textName"] as? String else{
                              return nil
                          }
                    settings.append(discussionSetting(textName: textName, textLink: textLink, questions: questions, criteria: criterias))
                }
                print("ready to send")
                print(settings)
                
                return Setting(code: code, textSettings: settings, registeredDate: dateString)
            })
            
            completion(.success(settings))
        })
    }
    
    
    public func recordDiscussionResult(with discussionId:String, speakFrequency: [Int], speakTime: [Int], usedQuestions:[questionSet], initialTime: Int, finishTime:Int, responseTypeCnt:[Int], lineCnt:Int, names:[String], classroomCode:String, completion: @escaping (Bool) -> Void){
        
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
            
            var usedQuestionData = [[String:Any]]()
            for question in usedQuestions {
                let questionData: [String:Any] =
                ["question":question.question,
                 "duration":question.duration]
                usedQuestionData.append(questionData)
            }
            print(usedQuestionData)
            
            let discussionResult: [String: Any] = [
                "FrequencyDistribution": speakFrequency,
                "startTime": startTimeString,
                "finishTime": endTimeString,
                "startTime_int":initialTime,
                "endTime_int":finishTime,
                "SpeakTimeDistribution": speakTime,
                "UsedQuestions": usedQuestionData,
                "responseTypeCnt": responseTypeCnt,
                "lineCnt": lineCnt
            ]
            
            if var result = userNode["discussionResult"] as? [[String:Any]]{
                
                result.append(discussionResult)
                
                userNode["discussionResult"] = result
                ref.setValue(userNode, withCompletionBlock: {[weak self] error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    self?.finishStudentRecord(with: names, classCode: classroomCode, speakFrequency: speakFrequency, speakTime: speakTime, discussionId: discussionId, duration: initialTime-finishTime, completion: completion)
                })
            }
            else{
                print("creating new")
                userNode["discussionResult"] = discussionResult
                
                ref.setValue(userNode, withCompletionBlock: {[weak self] error,_  in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    self?.finishStudentRecord(with: names, classCode: classroomCode, speakFrequency: speakFrequency, speakTime: speakTime, discussionId: discussionId, duration: initialTime-finishTime, completion: completion)
                })
            }
            completion(true)
        })
    }
    
    private func finishStudentRecord(with names:[String], classCode:String, speakFrequency: [Int], speakTime: [Int], discussionId:String, duration: Int, completion:  @escaping (Bool) -> Void){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
                return
        }
        let date = Date()
        let dateString = CreateDiscussionViewController.dateFormatter.string(from: date)
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        let ref = database.child("\(safeEmail)/classrooms")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [[String:Any]] else {
                completion(false)
                print("user not found")
                return
            }
            var cnt = 0
            if var classroom = userNode.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                cnt+=1
                return targetCode == classCode
            }){
                if var records = classroom["student_record"] as? [[String:Any]]{
                    var count=0
                    for record in records{
                        let name = record["name"]
                        let indexofN = names.firstIndex(of: name as! String)!
                        let result = ["frequency":speakFrequency[indexofN], "speakTime": speakTime[indexofN],"discussionId": discussionId, "date": dateString, "duration": duration] as [String : Any]
                        
                        if var rec = record["statistic"] as? [[String:Any]]{
                            rec.append(result)
                            records[count]["statistic"] = rec
                        }
                        else{
                            var recordData = [[String:Any]]()
                            recordData.append(result)
                            records[count]["statistic"] = recordData
                        }
                        count+=1
                    }
                    classroom["student_record"] = records
                    userNode[cnt-1] = classroom
                    ref.setValue(userNode, withCompletionBlock: { error,_  in
                        guard error == nil else{
                            completion(true)
                            return
                        }
                    })
                }
                completion(true)
            }
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
            
            print(newFlowEntry)
            
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
    
    public func getDiscussionSettings(with email:String, classroomCode: String, discussionID: String, completion: @escaping (Result<Setup, Error>) -> Void){
        
        database.child("\(email)/classrooms").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            if let classroom = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return classroomCode == targetCode
            }) {
                guard let collection = classroom["discussions"] as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                if let setting = collection.first(where: {
                    guard let targetID = $0["id"] as? String else {
                        return false
                    }
                    return discussionID == targetID
                }) {
                    guard let groupName = setting["group_name"] as? String,
                          let date = setting["date"] as? String ,
                          let settingCode = setting["setting_code"] as? String ,
                          let teacherName = setting["teacherName"] as? String,
                          let teacherEmail = setting["teacher_email"] as? String,
                          let discussionSetting = setting["discussion_setup"] as? [String:Any]
                    else {
                        print("could not fetch the setting")
                        return
                    }
                    let setup = Setup(date: date, groupName: groupName, id: discussionID, settingCode: settingCode, teacherName: teacherName, names: discussionSetting["name_setting"] as! [String], numParticipants: discussionSetting["num_students"] as! Int, tableSetting: discussionSetting["table_setting"] as! [Int], teacherEmail: teacherEmail)
                    completion(.success(setup))
                    return
                }
            }
            completion(.failure(DatabaseError.failedToFetch))
            return
        })
//        if(sort == "s"){
//            database.child("\(email)/discussions").observeSingleEvent(of: .value, with: { snapshot in
//                guard let collection = snapshot.value as? [[String: Any]] else {
//                    completion(.failure(DatabaseError.failedToFetch))
//                    return
//                }
//
//                if let setting = collection.first(where: {
//                    guard let targetID = $0["id"] as? String else {
//                        return false
//                    }
//                    return discussionID == targetID
//                }) {
//                    print(setting)
//                    guard let groupName = setting["group_name"] as? String,
//                          let date = setting["date"] as? String ,
//                          let settingCode = setting["setting_code"] as? String ,
//                          let teacherName = setting["teacherName"] as? String,
//                          let discussionSetting = setting["discussion_setup"] as? [String:Any]
//                    else {
//                        print("could not fetch the setting")
//                        return
//                    }
//                    let setup = Setup(date: date, groupName: groupName, id: discussionID, settingCode: settingCode, teacherName: teacherName, names: discussionSetting["name_setting"] as! [String], numParticipants: discussionSetting["num_students"] as! Int, tableSetting: discussionSetting["table_setting"] as! [Int])
//                    completion(.success(setup))
//                    return
//                }
//            })
//        }
//        else if (sort=="t"){
//
//        }
    }
    
    public func getSettingInfo(with email:String, code: String, completion: @escaping (Result<discussionSetting, Error>) -> Void){
        print("code:\(code), email: \(email)")
        database.child("\(email)/discussionSettings").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            if let regisSetting = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return code == targetCode
            }) {
                guard let collection = regisSetting["texts"] as? [[String: Any]]else{
                    print("here!!!")
                    return
                }
                
                let setting = collection[0]
                print("setting;")
                print(setting)
                guard let criterias = setting["criterias"] as? [String],
                      let questions = setting["questions"] as? [String],
                      let textLink = setting["textLink"] as? String ,
                      let textName = setting["textName"] as? String
                else {
                    print("could not fetch the information")
                    return
                }
                let setup = discussionSetting(textName: textName, textLink: textLink, questions: questions, criteria: criterias)
                
                print(setup)
                completion(.success(setup))
                return
                }
            })
        completion(.failure(DatabaseError.failedToFetch))
        return
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
    
    public func getStudentRecord(with classCode:String, name:String, completion: @escaping (Result<[participationRecord], Error>) -> Void){
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
                return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child("\(safeEmail)/classrooms").observe(.value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            if let setting = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return classCode == targetCode
            }) {
                guard let value = setting["student_record"] as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                if let student = value.first(where: {
                    guard let targetName = $0["name"] as? String else {
                        return false
                    }
                    return name == targetName
                }){
                    guard let value = student["statistic"] as? [[String: Any]] else{
                        print("does not have a statistic")
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    let record: [participationRecord] = value.compactMap({ dictionary in
                        guard let date = dictionary["date"] as? String,
                              let id = dictionary["discussionId"] as? String,
                              let frequency = dictionary["frequency"] as? Int,
                              let speakTime = dictionary["speakTime"] as? Int,
                              let duration = dictionary["duration"] as? Int else {
                                  print("!")
                                  return nil
                              }
                        
                        
                        
                        
                        
                        return participationRecord(date: date, discussionId: id, frequency: frequency, speakTime: speakTime, duration: duration)
                    })
                    completion(.success(record))
                    return
                }
            }
        })
    }
                    
    public func getDiscussionResult(with discussionId:String, completion: @escaping (Result<DiscResult, Error>) -> Void){
        
        database.child("\(discussionId)/discussionResult").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            guard let fdist = value["FrequencyDistribution"] as? [Int],
                  let sdist = value["SpeakTimeDistribution"] as? [Int],
                  let questions = value["UsedQuestions"] as? [[String:Any]],
                  let finishTime = value["endTime_int"] as? Int,
                  let startTime = value["startTime_int"] as? Int,
                  let lineCnt = value["lineCnt"] as? Int,
                  let responseTypeCnt = value["responseTypeCnt"] as? [Int]
            else {
                return
            }
            
            var questionData = [questionSet]()
            for i in questions {
                questionData.append(questionSet(question: i["question"] as! String, duration: i["duration"] as! Int))
            }
            
            let result = DiscResult(FrequencyDistribution: fdist, SpeakTimeDistribution: sdist, finishTime: finishTime, startTime: startTime, UsedQuestions: questionData, responseTypeCnt: responseTypeCnt, lineCnt: lineCnt)
            
            completion(.success(result))
        })
        
    }
    
    public func getAllClassrooms(for email: String, completion: @escaping (Result<[classrooms], Error>) -> Void) {
        database.child("\(email)/classrooms").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
//            print(value)
            
            let settings: [classrooms] = value.compactMap({ dictionary in
                guard let classroom = dictionary["class"] as? String,
                      let id = dictionary["code"] as? String,
                      let names = dictionary["students"] as? [String] else {
                          print("!")
                          return nil
                      }
                
                return classrooms(code: id, classroom: classroom, students: names)
            })
            completion(.success(settings))
        })
    }
    
    public func getAllDiscussionHistory(for email: String, classroomCode: String?, completion: @escaping (Result<[discussionHistory], Error>) -> Void) {
//        if(sort == "s"){
//            database.child("\(email)/discussions").observe(.value, with: { snapshot in
//                guard let value = snapshot.value as? [[String: Any]] else{
//                    completion(.failure(DatabaseError.failedToFetch))
//                    return
//                }
//                let settings: [discussionHistory] = value.compactMap({ dictionary in
//                    guard let name = dictionary["group_name"] as? String,
//                          let id = dictionary["id"] as? String,
//                          let date = dictionary["date"] as? String else {
//                              print("!")
//                              return nil
//                          }
//
//                    return discussionHistory(code: id, name: name, date: date)
//                })
//                completion(.success(settings))
//            })
//        }
        guard let classroomCode = classroomCode else {
            return
        }
        
        database.child("\(email)/classrooms").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            if let setting = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return classroomCode == targetCode
            }) {
                guard let value = setting["discussions"] as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                print(value)
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
                return
            }
            completion(.failure(DatabaseError.failedToFetch))
            return
        })
//        else if(sort == "t"){
//
//        }
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
    
    //teacher
    public func getAllTeacherRegisteredSettings(for email: String, classCode:String, completion: @escaping (Result<[registeredSetting], Error>) -> Void) {
        print(classCode)
        
        database.child("\(email)/classrooms").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            // iterate and find conversation with target sender
            if let setting = collection.first(where: {
                guard let targetCode = $0["code"] as? String else {
                    return false
                }
                return classCode == targetCode
            }) {
                guard let value = setting["registeredSettings"] as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                print(value)
                
                let settings: [registeredSetting] = value.compactMap({ dictionary in
                    guard let code = dictionary["code"] as? String,
                          let teacherEmail = dictionary["email"] as? String,
                          let teacherName = dictionary["name"] as? String else {
                              print("nil")
                              return nil
                          }
                    
                    return registeredSetting(code: code, teacherEmail: teacherEmail, teacherName: teacherName)
                })
                print(settings)
                completion(.success(settings))
                return
            }
            completion(.failure(DatabaseError.failedToFetch))
            return
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
    
    public func deleteCodeRegistered(discussioncode: String, classCode:String, completion: @escaping (Bool) -> Void) {
        print("deleting one with code : \(discussioncode) for \(classCode)")
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
                return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let ref = database.child("\(safeEmail)/classrooms")
        ref.observeSingleEvent(of: .value) {snapshot in
            if var classrooms = snapshot.value as? [[String: Any]] {
                var cnt = 0
                for classroom in classrooms{
                    if (classroom["code"] as! String == classCode){
                        var settings = classroom["registeredSettings"] as! [[String:Any]]
                        var positionToRemove = 0
                        for setting in settings {
                            if (setting["code"] as! String == discussioncode){
                                print("found code to delete")
                                break
                            }
                            positionToRemove += 1
                        }
                        settings.remove(at: positionToRemove)
                        classrooms[cnt]["registeredSettings"] = settings
                        break
                    }
                    cnt += 1
                }
//                print(classrooms[cnt])
//                completion(true)
                ref.setValue(classrooms, withCompletionBlock: {error, _ in
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
    
    public func deleteSettingRegistered(settingcode: String, completion: @escaping (Bool) -> Void) {
        print("deleting one with id : \(settingcode)")
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
                return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let ref = database.child("\(safeEmail)/discussionSettings")
        ref.observeSingleEvent(of: .value) {snapshot in
            if var discussions = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for discussion in discussions {
                    if let id  = discussion["code"] as? String,
                       id == settingcode {
                        print("found setting to delete")
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
    
    public func deleteClassroomRegistered(classcode: String, completion: @escaping (Bool) -> Void) {
        print("deleting one with id : \(classcode)")
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
                return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let ref = database.child("\(safeEmail)/classrooms")
        ref.observeSingleEvent(of: .value) {snapshot in
            if var classes = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for classroom in classes {
                    if let id  = classroom["code"] as? String,
                       id == classcode {
                        print("found class to delete")
                        break
                    }
                    positionToRemove += 1
                }
                
                classes.remove(at: positionToRemove)
                ref.setValue(classes, withCompletionBlock: {error, _ in
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
    
    public func deleteDiscussionHistory(discussionId: String, completion: @escaping (Bool) -> Void) {
        print("deleting one with id : \(discussionId)")
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
                return
        }
        
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


