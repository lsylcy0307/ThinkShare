import UIKit
import SnapKit

protocol TaskViewDelegate {
    func onRemove(_ view: TaskView)
}

class TaskView: UIView, InputViewDelegate, CriteriaViewDelegate {
//    func onCriteriaRemove(_ view: CriteriaView) {
//        <#code#>
//    }
//    
    func onInputRemove(_ view: CriteriaView) {
        if let first = self.stackView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.stackView.layoutIfNeeded()
            }
        }
    }
    
    func onCriteriaRemove(_ view: CriteriaView) {
        if let first = self.stackView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.stackView.layoutIfNeeded()
            }
        }
    }
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(self.horizontalStackView)
        stackView.addArrangedSubview(self.btnRemove)
        stackView.addArrangedSubview(self.nameInputStackView)
        stackView.addArrangedSubview(self.linkInputStackView)
        stackView.addArrangedSubview(self.inputStackView)
        stackView.addArrangedSubview(self.criteriaStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var criteriaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var Titlelabel:UILabel={
        let label = UILabel()
        label.text = "Text"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    
    var textNamelabel:UILabel={
        let label = UILabel()
        label.text = "Text name"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    
    var textNameInput:UITextField={
        let textField = UITextField()
        textField.font = UIFont(name: "ArialMT", size: 15)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor.white
        return textField
    }()
    
    var textLinklabel:UILabel={
        let label = UILabel()
        label.text = "Text link"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    
    var textLinkInput:UITextField={
        let textField = UITextField()
        textField.font = UIFont(name: "ArialMT", size: 15)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor.white
        return textField
    }()
    
    lazy var btnRemove: UIButton = {
        let btn = UIButton()
        btn.setTitle("Remove", for: .normal)
        btn.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        
        let constraint = btn.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
    
        btn.addTarget(self, action: #selector(btnRemoveTouchUpInside), for: .touchUpInside)
        return btn
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution  = .fillEqually
        stackView.addArrangedSubview(Titlelabel)
        stackView.addArrangedSubview(btnShow)
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(addCriteriaButton)
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    
    
    lazy var nameInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(self.textNamelabel)
        stackView.addArrangedSubview(self.textNameInput)
        stackView.distribution  = .fillEqually
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    
    lazy var linkInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(self.textLinklabel)
        stackView.addArrangedSubview(self.textLinkInput)
        stackView.distribution  = .fillEqually
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    lazy var addButton: UIButton  = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(addMoreTextField), for: .touchUpInside)
        return button
    }()
    
    lazy var addCriteriaButton: UIButton  = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor(cgColor: CGColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(addMoreCriteriaField), for: .touchUpInside)
        return button
    }()
    
    lazy var btnShow: UIButton = {
        let btn = UIButton()
        btn.setTitle("Hide", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1)), for: .normal)
        btn.layer.cornerRadius = 10
        
        btn.addTarget(self, action: #selector(btnShowTouchUpInside), for: .touchUpInside)
        return btn
    }()
    
    let delegate: TaskViewDelegate
    
    init(delegate: TaskViewDelegate) {
//        self.data = data
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = UIColor(cgColor: CGColor(red: 255/255, green: 242/255, blue: 198/255, alpha: 1))
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func btnShowTouchUpInside() {
        UIView.animate(withDuration: 0.2) {
            self.nameInputStackView.isHidden = !self.nameInputStackView.isHidden
            self.linkInputStackView.isHidden = !self.linkInputStackView.isHidden
            self.inputStackView.isHidden = !self.inputStackView.isHidden
            self.criteriaStackView.isHidden = !self.criteriaStackView.isHidden
        }
        
        if self.nameInputStackView.isHidden {
            btnShow.setTitle("Show", for: .normal)
        } else {
            btnShow.setTitle("Hide", for: .normal)
        }
    }
    
    @objc func addMoreTextField(){
        let view = InputView(delegate: self)
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 400.0)
        constraint1.isActive = true
        self.inputStackView.addArrangedSubview(view)
        self.inputStackView.layoutIfNeeded()
        self.stackView.layoutIfNeeded()
    }
    
    @objc func addMoreCriteriaField(){
        let view = CriteriaView(delegate: self)
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 400.0)
        constraint1.isActive = true
        self.criteriaStackView.addArrangedSubview(view)
        self.criteriaStackView.layoutIfNeeded()
        self.stackView.layoutIfNeeded()
    }
    
    @objc
    func btnRemoveTouchUpInside() {
        self.delegate.onRemove(self)
    }
    
    func onInputRemove(_ view: InputView) {
        if let first = self.inputStackView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.inputStackView.layoutIfNeeded()
            }
        }
    }
}
