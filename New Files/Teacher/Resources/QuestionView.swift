//
//  QuestionView.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/08/19.
//

import UIKit
import SnapKit

protocol QuestionViewDelegate {
    func onRemove(_ view: QuestionView)
}

class QuestionView: UIView {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(self.questionInputStackView)
        stackView.addArrangedSubview(self.btnRemove)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var Questionlabel:UILabel={
        let label = UILabel()
        label.text = "Question"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    var QuestionInput:UITextField={
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
    
    lazy var questionInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(Questionlabel)
        stackView.addArrangedSubview(QuestionInput)
        stackView.distribution  = .fillEqually
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 85)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    
    
    let delegate: QuestionViewDelegate
    
    init(delegate: QuestionViewDelegate) {
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
    func btnRemoveTouchUpInside() {
        self.delegate.onRemove(self)
    }
    
}
