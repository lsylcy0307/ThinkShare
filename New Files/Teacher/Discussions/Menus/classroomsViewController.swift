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
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create a classroom", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        return button
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
        
        createButton.addTarget(self,
                             action: #selector(didTapCreate),
                             for: .touchUpInside)
        
        view.addSubview(createButton)
        view.addSubview(tableView)
        view.addSubview(noSettingsLabel)
        setupTableView()
        getHistory()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func didTapCreate(){
        let vc = createClassViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
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
        createButton.frame = CGRect(x: 20,
                                  y: 80,
                                  width: 250,
                                  height: 50)
        tableView.frame = CGRect(x: 0, y: 150, width: view.width, height: view.height-150)
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let classcode = classes[indexPath.row].code
                print(classcode)
                tableView.beginUpdates()
                self.classes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)

                DatabaseManager.shared.deleteClassroomRegistered(classcode: classcode, completion: { success in
                    if !success {
                        // add  model and row back and show error alert
                    }
                    print("deleted")
                })

                tableView.endUpdates()
            }
        }

}
