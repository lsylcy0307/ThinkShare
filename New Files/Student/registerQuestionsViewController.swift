

import UIKit
import JGProgressHUD

class registerQuestionsViewController: UIViewController, QuestionViewDelegate {
    
    var discussionId = ""
    private let spinner = JGProgressHUD(style: .dark)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
    
    private var count = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Question Post"
        self.view.backgroundColor = .white
        addLeftBarButton()
        addRightBarButton()
        
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finished", style: .done, target: self, action: #selector(nextButtonTapped))
    }
    
    @objc func addMoreView() {
        count += 1
        let view = QuestionView(delegate: self)
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 85)
        constraint1.isActive = true
        self.taskStackView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scrollView doesn't scroll to the bottom
        scrollView.frame = view.bounds
    }
    
    func onRemove(_ view: QuestionView) {
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
    
    @objc func nextButtonTapped(){
        //add to the database
        //post notification
        var questionData = [String]()
        
        for eachStackView in self.taskStackView.arrangedSubviews {
            if let taskview = eachStackView as? QuestionView
            {
                guard let question = taskview.QuestionInput.text else {
                    return
                }
                questionData.append(question)
            }
        }
        
        
        NotificationCenter.default.post(name: DiscussionViewController.addQuestionNotification, object: nil, userInfo: ["questions": questionData])
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
}
