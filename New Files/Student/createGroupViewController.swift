

import UIKit
import JGProgressHUD

class createGroupViewController: UIViewController, NamesViewDelegate {
    
    private let spinner = JGProgressHUD(style: .dark)
    var student_names = [String]()
    
    var setting:registeredSetting?
    var names = [String]()
    var modeSwitch = false
    
    private var discussion_id = ""
    
    @IBOutlet weak var groupNameField: UITextField!
//    @IBOutlet weak var numBoysField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var namesView: UIView!
    @IBOutlet weak var stepper: UIStepper! //adding participants
    
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
        addBtn.isEnabled = true
        
        backBtn.layer.cornerRadius = 12
        continueBtn.layer.cornerRadius = 12
        
        continueBtn.isEnabled = false
        
        [groupNameField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
        namesView.addSubview(scrollView)
        scrollView.addSubview(taskStackView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(namesView)
        }
        
        taskStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scrollView doesn't scroll to the bottom
        scrollView.frame = namesView.bounds
    }
    
    @IBAction func addPart(_ sender: Any) {
        count += 1
        let view = NamesView(delegate: self)
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 85)
        constraint1.isActive = true
        self.taskStackView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
        
        if count >= 14 {
            addBtn.isEnabled = false
        }
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
        window.rootViewController = ContainerViewController()
        window.makeKeyAndVisible()
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
        
        var nameData = [String]()
        
        for eachStackView in self.taskStackView.arrangedSubviews {
            if let taskview = eachStackView as? NamesView
            {
                guard let name = taskview.NamesInput.text else {
                    return
                }
                nameData.append(name)
            }
        }
        
        spinner.show(in: view)
        names = nameData
        
        guard let groupName = groupNameField.text else {return}
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "ParticipantsView") as! ParticipantsViewController
        mainViewController.participant = count
        mainViewController.partNames = names
        mainViewController.setting = setting
        mainViewController.num_students = count
        mainViewController.groupName = groupName
        mainViewController.modeSwitch = modeSwitch
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
