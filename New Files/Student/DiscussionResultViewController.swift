//
//  DiscussionResultViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/10/24.
//

import UIKit
import Foundation

struct Setup {
    let date: String
    let groupName: String
    let id: String
    let settingCode: String
    let teacherName: String
    let names: [String]
    let numParticipants: Int
    let tableSetting: [Int]
}

class DiscussionResultViewController: UIViewController {
    var discussionId = ""
    var discussionFlows = [flow]()
    var discussionSetup: Setup?
    let responseTypes = ["agreement", "change", "expand", "disagreement"]
//    var speakTime = [Int]()
//    var speakFrequency = [Int]()
    var responseTypeCnt = [Int]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(discussionId)
        loadDiscussionSetting()
    }
    
    private func loadDiscussionSetting(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    
        DatabaseManager.shared.getDiscussionSettings(with: safeEmail, discussionID: discussionId, completion: { [weak self] result in
            switch result {
            case .success(let setup):
                self?.discussionSetup = setup
//                print(self?.discussionSetup)
                self?.getDiscussionFlow()
            case .failure(let error):
                print("failed to get flows: \(error)")
            }
        })
    }
    
    
    private func getDiscussionFlow(){
        DatabaseManager.shared.getDiscussionFlow(with: discussionId, completion: { [weak self]result in
            switch result {
            case .success(let flows):
                self?.discussionFlows = flows
                print(flows)
            case .failure(let error):
                print("failed to get flows: \(error)")
            }
        })
        
//        interpretFlow()
    }
    
    func interpretFlow(){
        
//        var speaksFrequency = [Int](count: discussionSetup?.numParticipants, repeatedValue: 0)
//        var speakTime = [Int](count: discussionSetup?.numParticipants, repeatedValue: 0)
//
        for flow in discussionFlows{
            for response in flow.responseType {
                if (response == "agreement"){
                    responseTypeCnt[0]+=1
                }
                else if (response == "change"){
                    responseTypeCnt[1]+=1
                }
                else if (response == "expand"){
                    responseTypeCnt[2]+=1
                }
                else if (response == "disagreement"){
                    responseTypeCnt[3]+=1
                }
            }
        }
    }

}
