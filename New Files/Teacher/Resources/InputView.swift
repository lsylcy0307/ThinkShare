import UIKit
import SnapKit

protocol InputViewDelegate {
    func onInputRemove(_ view: InputView)
}

class InputView: UIView {
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution  = .fillEqually
        stackView.addArrangedSubview(lblTitle)
        stackView.addArrangedSubview(textInput)
        stackView.addArrangedSubview(btnRemove)
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    
    lazy var btnRemove: UIButton = {
        let btn = UIButton()
        btn.setTitle("-", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0))
        btn.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        btn.layer.cornerRadius = 10
        let constraint = btn.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        btn.addTarget(self, action: #selector(btnRemoveTouchUpInside), for: .touchUpInside)
        return btn
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Question"
        lbl.font = UIFont(name: "ArialMT", size: 15)
        return lbl
    }()
    
    var textInput: UITextField={
        let textField = UITextField()
        textField.font = UIFont(name: "ArialMT", size: 15)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor.white
        return textField
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let delegate: InputViewDelegate
    
    init(delegate: InputViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = UIColor(cgColor: CGColor(red: 252/255, green: 197/255, blue: 0/255, alpha: 1))
        self.layer.cornerRadius = 10
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10))
        }
    }
    
    
   @objc
    func btnRemoveTouchUpInside() {
        self.delegate.onInputRemove(self)
    }
}
