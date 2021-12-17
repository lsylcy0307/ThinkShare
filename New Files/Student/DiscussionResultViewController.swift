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

struct DiscResult {
    let FrequencyDistribution: [Int]
    let SpeakTimeDistribution: [Int]
    let finishTime: Int
    let startTime: Int
    let UsedQuestions: [questionSet]
    let responseTypeCnt: [Int]
}


class DiscussionResultViewController: UIViewController {
    var discussionId = ""
    var discussionFlows = [flow]()
    var discussionSetup: Setup?
    var discussionResult: DiscResult?
    let responseTypes = ["agreement", "change", "expand", "disagreement"]
    var speakTime = [Int]()
    var initialTime = Int()
    var finishTime = Int()
    var speakFrequency = [Int]()
    var responseTypeCnt = [Int]()
    var usedquestions = [questionSet]()
    var names = ["","","","","","","","", "","","","", "","","",""]
    var tableNames = [String]()
    

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
                self?.getDiscussionFlow()
                self?.getDiscussionResult()
            case .failure(let error):
                print("failed to get flows: \(error)")
            }
        })
        
        
    }
    
    
    private func getDiscussionFlow(){
        DatabaseManager.shared.getDiscussionFlow(with: discussionId, completion: { [weak self] result in
            switch result {
            case .success(let flows):
                self?.discussionFlows = flows
            case .failure(let error):
                print("failed to get flows: \(error)")
            }
        })
    }
    
    private func getDiscussionResult(){
        DatabaseManager.shared.getDiscussionResult(with: discussionId, completion: { [weak self] result in
            switch result {
            case .success(let result):
                self?.discussionResult = result
                self?.interpretFlow()
            case .failure(let error):
                print("failed to get flows: \(error)")
            }
        })
        
    }
    
    func interpretFlow(){
        print("called setup")
        print(discussionSetup)
        print("------")
        print(discussionResult)
        
        var cnt = 0
        for i in discussionSetup!.tableSetting {
            names[i-1] = discussionSetup!.names[cnt]
            cnt += 1
        }
        speakFrequency = self.discussionResult!.FrequencyDistribution
        speakTime = self.discussionResult!.SpeakTimeDistribution
        usedquestions = self.discussionResult!.UsedQuestions
        responseTypeCnt = self.discussionResult!.responseTypeCnt
        initialTime = self.discussionResult!.startTime
        finishTime = self.discussionResult!.finishTime
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyBoard.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        resultVC.tableName = names
        resultVC.speakFrequency = speakFrequency
        resultVC.discussionId = discussionId
        resultVC.speakTime = speakTime
        resultVC.questions = usedquestions
        resultVC.initialTime = initialTime
        resultVC.finishTime = finishTime
        resultVC.responseTypeCnt = responseTypeCnt
        
        resultVC.modalPresentationStyle = .overFullScreen
        self.present(resultVC, animated: true, completion: nil)
    }

}
