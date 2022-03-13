//
//  classroomsViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/15.
//

import UIKit
import JGProgressHUD

struct classrooms {
    let code: String
    let classroom: String
    let students: [String]
}

protocol loadViewDelegate: AnyObject {
    func onLoadView(with info: classrooms?, page: Int)
}

class classroomsViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    private var classes = [classrooms]()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(DiscussionHistoryTableViewCell.self,
                       forCellReuseIdentifier: DiscussionHistoryTableViewCell.identifier)
        return table
    }()
    
    private let noSettingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Start a new class!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "classrooms"
        view.backgroundColor = .white
        view.tag = 4
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

        DatabaseManager.shared.getAllClassrooms(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let classroom):
                guard !classroom.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noSettingsLabel.isHidden = false
                    return
                }
    
                self?.noSettingsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.classes = classroom
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
    

    
    weak var delegate:loadViewDelegate?

}

extension classroomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = classes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscussionHistoryTableViewCell.identifier,
                                                 for: indexPath) as! DiscussionHistoryTableViewCell
        cell.configure(with: discussionHistory(code: model.code, name: model.classroom, date: ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slcClass = classes[indexPath.row]
        delegate?.onLoadView(with: slcClass, page: 1)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }

}
