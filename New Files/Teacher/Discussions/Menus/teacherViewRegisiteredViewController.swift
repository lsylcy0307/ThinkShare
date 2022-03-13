//
//  teacherViewRegisiteredViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/19.
//

import UIKit
import JGProgressHUD

class teacherViewRegisiteredViewController: UIViewController {
    public var classInfo: classrooms?
    weak var popDelegate:popClassVCDelegate?

    private let spinner = JGProgressHUD(style: .dark)

    private var settings = [registeredSetting]()
    private var selected: registeredSetting?
    
    lazy var groupVC = createGroupViewController()
    
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
        table.register(RegisteredSettingsTableViewCell.self,
                       forCellReuseIdentifier: RegisteredSettingsTableViewCell.identifier)
        return table
    }()

    private let noSettingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ask your teacher for a code!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.tag = 6
        
        backButton.addTarget(self,
                             action: #selector(didTapBack),
                             for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(noSettingsLabel)
        view.addSubview(backButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "\(classInfo!.classroom): new discussion"
        setupTableView()
        getRegisteredDiscussions()
    }
    
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func getRegisteredDiscussions(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("starting discussion settings fetch...")
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        DatabaseManager.shared.getAllTeacherRegisteredSettings(for: safeEmail, classCode: classInfo!.code, completion: { [weak self] result in
            switch result {
            case .success(let settings):
                guard !settings.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noSettingsLabel.isHidden = false
                    return
                }
                self?.noSettingsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.settings = settings

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
        tableView.frame = CGRect(x: 0, y: 150, width: view.width, height: view.height-150)
        backButton.frame = CGRect(x: 20,
                                  y: 80,
                                  width: 200,
                                  height: 50)
        noSettingsLabel.frame = CGRect(x: 10,
                                          y: (view.height-100)/2,
                                          width: view.width-20,
                                          height: 100)
    }
    
    @objc private func didTapBack(){
        popDelegate?.onPopView()
    }
    
}


extension teacherViewRegisiteredViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RegisteredSettingsTableViewCell.identifier,
                                                 for: indexPath) as! RegisteredSettingsTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedModel = settings[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let discussionVC = storyBoard.instantiateViewController(withIdentifier: "createView") as! createGroupViewController
        discussionVC.setting = selectedModel
        discussionVC.names = classInfo!.students
//        discussionVC.sort = "t"
        discussionVC.classroomCode = classInfo!.code
        discussionVC.title = selectedModel.code
        
        let navVC = UINavigationController(rootViewController: discussionVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // begin delete
                let discussioncode = settings[indexPath.row].code
                tableView.beginUpdates()
                self.settings.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)

                
//                DatabaseManager.shared.deleteCodeRegistered(discussioncode: discussioncode, completion: { success in
//                    if !success {
//                        // add  model and row back and show error alert
//                    }
//                })

                tableView.endUpdates()
            }
        }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
