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

import UIKit
import JGProgressHUD

class HistoryViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var discussions = [discussionHistory]()
    
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
        title = "History"
        view.backgroundColor = .white
        view.tag = 3
        view.addSubview(tableView)
        view.addSubview(noSettingsLabel)
        setupTableView()
        getHistory()
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

        DatabaseManager.shared.getAllDiscussionHistory(for: safeEmail, completion: { [weak self] result in
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
        tableView.frame = view.bounds
        noSettingsLabel.frame = CGRect(x: 10,
                                          y: (view.height-100)/2,
                                          width: view.width-20,
                                          height: 100)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedModel = discussions[indexPath.row]
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let discussionVC = storyBoard.instantiateViewController(withIdentifier: "createView") as! createGroupViewController
//        discussionVC.setting = selectedModel
//        discussionVC.title = selectedModel.code
//
//        let navVC = UINavigationController(rootViewController: discussionVC)
//        navVC.modalPresentationStyle = .overFullScreen
//        self.present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
}
