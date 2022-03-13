//
//  createClassViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/15.
//

import UIKit

class createClassViewController: UIViewController, nameViewDelegate {
    
    var classNamelabel:UILabel={
        let label = UILabel()
        label.text = "class name"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    
    var classNameInput:UITextField={
        let textField = UITextField()
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        textField.font = UIFont(name: "ArialMT", size: 15)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        
        textField.backgroundColor = UIColor.white
        return textField
    }()
    
    lazy var classInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(self.classNamelabel)
        stackView.addArrangedSubview(self.classNameInput)
        stackView.distribution  = .fillEqually
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    
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
        
        self.title = "New Class"
        self.view.backgroundColor = .white
        addLeftBarButton()
        addRightBarButton()
        view.addSubview(scrollView)
        scrollView.addSubview(taskStackView)
        view.addSubview(classInputStackView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        taskStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        classInputStackView.frame = CGRect(x: 50,
                                           y: 70,
                                           width: 300,
                                           height: 30)
        scrollView.frame = CGRect(x: 0,
                                  y: classInputStackView.bottom+10,
                                  width: view.width,
                                  height: view.height-40)
    }
    
    private func addLeftBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addMoreView))
    }
    
    private func addRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(nextButtonTapped))
    }
    
    @objc
    func addMoreView() {
        count += 1
        let view = nameView(delegate: self)
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 400.0)
        constraint1.isActive = true
        self.taskStackView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    
    @objc func nextButtonTapped(){
        //add to the database
        var data:[String] = ["Teacher"] //default name with Teacher
        for eachStackView in self.taskStackView.arrangedSubviews {
            if let nameview = eachStackView as? nameView
            {
                guard let textName = nameview.studentNameInput.text else {
                    return
                }
                
                data.append(textName)
            }
        }
        if(data.isEmpty != true){
            guard let className = classNameInput.text else {
                return
            }
            DatabaseManager.shared.addClassroom(with: data, className: className, names:data, completion: {success in
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
    
    
    private func backToMain(){
        print("dismiss")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func onRemove(_ view: nameView) {
        count -= 1
        if let first = self.taskStackView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }
    }

}
