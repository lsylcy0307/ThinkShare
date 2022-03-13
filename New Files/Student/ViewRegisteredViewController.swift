
struct registeredSetting {
    let code: String
    let teacherEmail: String
    let teacherName: String
}

import UIKit
import JGProgressHUD

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class ViewRegisteredViewController: UIViewController {
    weak var delegate: HomeViewControllerDelegate?
    private let spinner = JGProgressHUD(style: .dark)

    private var settings = [registeredSetting]()
    private var selected: registeredSetting?
    
    lazy var groupVC = createGroupViewController()

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
        
        //temporary, need to be solved - login, user issue
        title = "Start a new discussion"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(TapMenuButton))
        view.backgroundColor = .white
//        view.tag = 3
        view.addSubview(tableView)
        view.addSubview(noSettingsLabel)
        setupTableView()
        getRegisteredDiscussions()
    }
    
    @objc func TapMenuButton(){
        delegate?.didTapMenuButton()
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

        DatabaseManager.shared.getAllUserRegisteredSettings(for: safeEmail, completion: { [weak self] result in
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
        tableView.frame = view.bounds
        noSettingsLabel.frame = CGRect(x: 10,
                                          y: (view.height-100)/2,
                                          width: view.width-20,
                                          height: 100)
    }
}


extension ViewRegisteredViewController: UITableViewDelegate, UITableViewDataSource {
    
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
//        discussionVC.sort = "s"
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

                DatabaseManager.shared.deleteCodeRegistered(discussioncode: discussioncode, completion: { success in
                    if !success {
                        // add  model and row back and show error alert
                    }
                })

                tableView.endUpdates()
            }
        }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
