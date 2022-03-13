

import UIKit
import JGProgressHUD

class createGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    public var sort = ""
    public var classroomCode = ""
    private let spinner = JGProgressHUD(style: .dark)
//    public var student_names = [String]()
    
    var setting:registeredSetting?
    public var names = [String]()
    var modeSwitch = false
    
    private var discussion_id = ""
    
    @IBOutlet weak var groupNameField: UITextField!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var namesView: UIView!
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var count = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        `switch`.setOn(false, animated: false)
        print("student names: \(names)")
        backBtn.layer.cornerRadius = 12
        continueBtn.layer.cornerRadius = 12
        
        continueBtn.isEnabled = false
        
        [groupNameField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
//        namesView.addSubview(scrollView)
        namesView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
//
//        scrollView.snp.makeConstraints { (make) in
//            make.edges.equalTo(namesView)
//        }
//
//        taskStackView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//            make.width.equalTo(scrollView)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scrollView doesn't scroll to the bottom
        tableView.frame = namesView.bounds
    }
    
    func onRemove(_ view: NamesView) {
        count -= 1
        print(count)
        if let first = self.taskStackView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }
    }
    

    @IBAction func backTapped(_ sender: Any) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        window.rootViewController = TeacherContainerViewController()
        window.makeKeyAndVisible()
        
//        if(sort == "s"){
//            window.rootViewController = ContainerViewController()
//            window.makeKeyAndVisible()
//        }
//        else if(sort == "t"){
//            window.rootViewController = TeacherContainerViewController()
//            window.makeKeyAndVisible()
//        }
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            modeSwitch = true
            print(modeSwitch)
        }
        else{
            modeSwitch = false
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        print("continue tapped")
        save()
        
    }
    
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let group = groupNameField.text, !group.isEmpty
        else {
            continueBtn.isEnabled = false
            return
        }
        continueBtn.isEnabled = true
    }
    
    func alertCreateError(message: String = "Please enter all information to create a new discussion.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func save(){
        
//        var nameData = [String]()
//
//        for eachStackView in self.taskStackView.arrangedSubviews {
//            if let taskview = eachStackView as? NamesView
//            {
//                guard let name = taskview.NamesInput.text else {
//                    return
//                }
//                nameData.append(name)
//            }
//        }
//
//        spinner.show(in: view)
//        names = nameData
        
        guard let groupName = groupNameField.text else {return}
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "ParticipantsView") as! ParticipantsViewController
        mainViewController.participant = names.count
        mainViewController.classroomCode = classroomCode
        mainViewController.partNames = names
        mainViewController.setting = setting
        mainViewController.num_students = names.count
        mainViewController.groupName = groupName
        mainViewController.modeSwitch = modeSwitch
//        mainViewController.sort = sort
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        cell.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1)
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: "ArialMT", size: 15)
        return cell
    }
    
}
