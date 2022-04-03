
import UIKit

struct discussionSetting {
    let textName : String
    let textLink : String
    let questions : [String]
    let criteria: [String]
}

struct Setting {
    let code: String
    let textSettings: [discussionSetting]
    let registeredDate: String
}

class CreateDiscussionViewController: UIViewController, TaskViewDelegate {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    public static let dateFormatter: DateFormatter = {
            let formattre = DateFormatter()
            formattre.dateStyle = .medium
            formattre.timeStyle = .long
            formattre.locale = .current
            return formattre
        }()
    
    lazy var taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//    private var count = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Discussion Settings"
        self.view.backgroundColor = .white
//        addLeftBarButton()
        addRightBarButton()
        addMoreView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(taskStackView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        taskStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
    private func addLeftBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addMoreView))
    }
    
    private func addRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(nextButtonTapped))
    }
    
    @objc
    func addMoreView() {
//        count += 1
        let view = TaskView(delegate: self)
//        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 400.0)
//        constraint1.isActive = true
        self.taskStackView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
//        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    @objc func nextButtonTapped(){
        //add to the database
//        var textNameData = ""
        var data = [discussionSetting]()
        for eachStackView in self.taskStackView.arrangedSubviews {
            if let taskview = eachStackView as? TaskView
            {
                guard let textName = taskview.textNameInput.text else {
                    return
                }
//                textNameData = textName
                
                var questions:[String] = []
                for eachInputView in taskview.inputStackView.arrangedSubviews {
                    if let inputview = eachInputView as? InputView
                    {
                        guard let question = inputview.textInput.text else {
                            return
                        }
                        if(question != "" ){
                            questions.append(question)
                        }
                    }
                }
                var criterias:[String] = []
                for eachInputView in taskview.criteriaStackView.arrangedSubviews {
                    if let criteriaview = eachInputView as? CriteriaView
                    {
                        guard let criteria = criteriaview.textInput.text else {
                            return
                        }
                        if(criteria != "" ){
                            criterias.append(criteria)
                        }
                        
                    }
                }
                
                if((criterias.isEmpty != true) && (questions.isEmpty != true) && (textName != "")){
                    let dataPoint = discussionSetting(textName: textName, textLink: " ", questions: questions, criteria: criterias)
                    data.append(dataPoint)
                }
            }
        }
        if((data.isEmpty != true)){
            DatabaseManager.shared.addDiscussionSetting(with: data, completion: {success in
                if success {
                    print("successfully added the discussion setting")
                    self.backToMain()
                }
            })
        }
        else{
            self.backToMain()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    
    private func backToMain(){
        print("dismiss")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func onRemove(_ view: TaskView) {
//        count -= 1
        if let first = self.taskStackView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
}
