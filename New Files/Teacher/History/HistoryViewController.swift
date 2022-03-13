//
//  HistoryViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/09/26.
//

struct discussionHistory {
    let code: String
    let name: String
    let date: String
}

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
    let lineCnt : Int
}



import UIKit
import JGProgressHUD

class HistoryViewController: UIViewController {
    weak var popDelegate:popClassVCDelegate?
    public var sort=""
    public var classInfo:classrooms?
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
    var lineCnt = 0
    var usedquestions = [questionSet]()
    var names = ["","","","","","","","", "","","","", "","","",""]
    var tableNames = [String]()
    
    private let spinner = JGProgressHUD(style: .dark)
    public var identity = ""
    private var discussions = [discussionHistory]()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(DiscussionHistoryTableViewCell.self,
                       forCellReuseIdentifier: DiscussionHistoryTableViewCell.identifier)
        return table
    }()

    private let noSettingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Start a new discussion!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self,
                             action: #selector(didTapBack),
                             for: .touchUpInside)
        
        title = "History"
        view.backgroundColor = .white
        view.tag = 8
        view.addSubview(tableView)
        view.addSubview(noSettingsLabel)
//        guard let identity = UserDefaults.standard.value(forKey: "identity") as? String else {
//            return
//       }
//        if (identity == "Teacher"){
//            print(identity)
//            self.identity = "Teacher"
//            view.addSubview(backButton)
//        }
//        else{
//            self.identity = "Students"
//        }
    }
    
    
    @objc private func didTapBack(){
        popDelegate?.onPopView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.setupTableView()
            self.getHistory()
        }
//        if(sort == "t"){
//            DispatchQueue.main.async {
//                self.setupTableView()
//                self.getHistory()
//            }
//        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func getHistory(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        print(sort)
        DatabaseManager.shared.getAllDiscussionHistory(for: safeEmail, classroomCode: classInfo?.code,completion: { [weak self] result in
            switch result {
            case .success(let histories):
                guard !histories.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noSettingsLabel.isHidden = false
                    return
                }
                
                self?.noSettingsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.discussions = histories
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noSettingsLabel.isHidden = false
                print("failed to get convos: \(error)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: 20,
                                  y: 80,
                                  width: 200,
                                  height: 50)
//        if(self.identity == "Teacher"){
//            backButton.frame = CGRect(x: 20,
//                                      y: 80,
//                                      width: 200,
//                                      height: 50)
//        }
        tableView.frame = CGRect(x: 0, y: 150, width: view.width, height: view.height-150)
        noSettingsLabel.frame = CGRect(x: 10,
                                          y: (view.height-100)/2,
                                          width: view.width-20,
                                          height: 100)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(discussions.count)
        print(discussions)
        return discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = discussions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscussionHistoryTableViewCell.identifier,
                                                 for: indexPath) as! DiscussionHistoryTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        spinner.show(in: view)
        
        let selectedModel = discussions[indexPath.row]
        let discussionID = selectedModel.code
        
        self.discussionId = discussionID
        print(self.discussionId)
        self.loadDiscussionSetting()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // begin delete
                let discussionId = discussions[indexPath.row].code
                print("tring to delete: \(discussionId)")
                tableView.beginUpdates()
                self.discussions.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)

                DatabaseManager.shared.deleteDiscussionHistory(discussionId: discussionId, completion: { success in
                    if !success {
                        // add  model and row back and show error alert
                    }
                })

                tableView.endUpdates()
            }
        }
    
    private func loadDiscussionSetting(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    
        DatabaseManager.shared.getDiscussionSettings(with: safeEmail, sort: sort, classroomCode: classInfo!.code, discussionID: discussionId, completion: { [weak self] result in
            switch result {
            case .success(let setup):
                self?.discussionSetup = setup
                self?.getDiscussionFlow()
                self?.getDiscussionResult()
            case .failure(let error):
                print("failed to get settings: \(error)")
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
                print("failed to get result: \(error)")
            }
        })
        
    }
    
    private func interpretFlow(){
        
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
        lineCnt = self.discussionResult!.lineCnt
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let resultVC = storyBoard.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        let resultVC = ResultViewController()
        
        resultVC.tableName = names
        resultVC.speakFrequency = speakFrequency
        resultVC.discussionId = discussionId
        resultVC.speakTime = speakTime
        resultVC.questions = usedquestions
        resultVC.initialTime = initialTime
        resultVC.lineCnt = self.lineCnt
        resultVC.finishTime = finishTime
        resultVC.numParticipants = discussionSetup!.numParticipants
        resultVC.responseTypeCnt = responseTypeCnt
        
        
        let navVC = UINavigationController(rootViewController: resultVC)
        navVC.modalPresentationStyle = .overFullScreen
        
        self.spinner.dismiss()
        self.present(navVC, animated: true)
    }
    
}
