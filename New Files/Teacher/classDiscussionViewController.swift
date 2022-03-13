//
//  classDiscussionViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/17.
//

import UIKit

protocol popClassVCDelegate: AnyObject {
    func onPopView()
}

class classDiscussionViewController: UIViewController {
    
    weak var delegate:loadViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(red: 253/255, green: 242/255, blue: 231/255, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 40)
        return button
    }()

    
    private let registeredListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Codes", for: .normal)
        button.backgroundColor = UIColor(red: 253/255, green: 242/255, blue: 231/255, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 40)
        return button
    }()
    
    private let historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("History", for: .normal)
        button.backgroundColor = UIColor(red: 253/255, green: 242/255, blue: 231/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 40)
        return button
    }()
    
    public var classInfo:classrooms?
    weak var popDelegate:popClassVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "discussions for class"
        view.backgroundColor = .white
        view.tag = 5
        
        backButton.addTarget(self,
                             action: #selector(didTapBack),
                             for: .touchUpInside)
        registerButton.addTarget(self,
                              action: #selector(didTapRegister),
                              for: .touchUpInside)
        registeredListButton.addTarget(self,
                                       action: #selector(didTapList),
                                       for: .touchUpInside)
        historyButton.addTarget(self,
                                       action: #selector(didTapHistory),
                                       for: .touchUpInside)
        view.addSubview(registerButton)
        view.addSubview(registeredListButton)
        view.addSubview(historyButton)
        view.addSubview(backButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: 20,
                                  y: 80,
                                  width: 200,
                                  height: 50)
        registerButton.frame = CGRect(x: view.frame.size.width/8,
                                   y: view.frame.size.height/4,
                                   width: view.frame.size.width/4,
                                   height: view.frame.size.height/2)
        registeredListButton.frame = CGRect(x: registerButton.right + 15,
                                            y: view.frame.size.height/4,
                                            width: view.frame.size.width/4,
                                            height: view.frame.size.height/2)
        historyButton.frame = CGRect(x:registeredListButton.right + 15,
                                    y: view.frame.size.height/4,
                                    width: view.frame.size.width/4,
                                    height: view.frame.size.height/2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = classInfo?.classroom
    }
    @objc private func didTapBack(){
        popDelegate?.onPopView()
    }
    
    @objc private func didTapRegister(){
        delegate?.onLoadView(with: classInfo, page: 2)
    }
    
    @objc private func didTapList(){
        delegate?.onLoadView(with: classInfo, page: 3)
    }
    
    @objc private func didTapHistory(){
        delegate?.onLoadView(with: classInfo, page: 4)
    }


}
