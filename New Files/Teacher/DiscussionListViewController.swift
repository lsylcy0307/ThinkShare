//
//  DiscussionListViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/07/31.
//
import UIKit
import FirebaseAuth
import JGProgressHUD


class DiscussionListViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var discussions = [Setting]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(DicussionListTableViewCell.self,
                       forCellReuseIdentifier: DicussionListTableViewCell.identifier)
        return table
    }()
    
    private let noDiscussionsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Discussions!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = add
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(noDiscussionsLabel)
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
        
        DatabaseManager.shared.getAllDiscussionSettings(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let settings):
                print("successfully got discussion setting models")
                print("in the list:  ")
                print(settings)
                guard !settings.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noDiscussionsLabel.isHidden = false
                    return
                }
                self?.noDiscussionsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.discussions = settings
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noDiscussionsLabel.isHidden = false
                print("failed to get convos: \(error)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noDiscussionsLabel.frame = CGRect(x: 10,
                                          y: (view.height-100)/2,
                                          width: view.width-20,
                                          height: 100)
    }
    
    @objc func addTapped(){
        
        guard let identity = UserDefaults.standard.value(forKey: "identity") as? String else {
            return
        }
        if (identity == "Students"){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenusViewController
            mainViewController.modalPresentationStyle = .fullScreen
            self.present(mainViewController, animated: true, completion: nil)
        }
        else if (identity == "Teacher"){
            let vc = TeacherMenuViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
            self.present(nav, animated: true)
        }
    }
    
}

extension DiscussionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = discussions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DicussionListTableViewCell.identifier,
                                                 for: indexPath) as! DicussionListTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = discussions[indexPath.row]
        print(model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
}
