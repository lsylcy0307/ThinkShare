//
//  nameView.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/15.
//

import Foundation
import UIKit
import SnapKit

protocol nameViewDelegate {
    func onRemove(_ view: nameView)
}

class nameView: UIView {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(self.horizontalStackView)
        stackView.addArrangedSubview(self.btnRemove)
        stackView.addArrangedSubview(self.nameInputStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    var Titlelabel:UILabel={
        let label = UILabel()
        label.text = "Student"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    
    var studentNamelabel:UILabel={
        let label = UILabel()
        label.text = "Student name"
        label.font = UIFont(name: "ArialMT", size: 15)
        return label
    }()
    
    var studentNameInput:UITextField={
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
//        stackView.addArrangedSubview(addButton)
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
    }()
    
    
    lazy var nameInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(self.studentNamelabel)
        stackView.addArrangedSubview(self.studentNameInput)
        stackView.distribution  = .fillEqually
        let constraint = stackView.heightAnchor.constraint(equalToConstant: 30)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(rawValue: 999)
        return stackView
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
    
    let delegate: nameViewDelegate
    
    init(delegate: nameViewDelegate) {
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
        }
        
        if self.nameInputStackView.isHidden {
            btnShow.setTitle("Show", for: .normal)
        } else {
            btnShow.setTitle("Hide", for: .normal)
        }
    }
    
    @objc
    func btnRemoveTouchUpInside() {
        self.delegate.onRemove(self)
    }
}

