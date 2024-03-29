//
//  teacherRegisterViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/18.
//

import UIKit

class teacherRegisterViewController: UIViewController {
    weak var popDelegate:popClassVCDelegate?
    public var classroomCode: String?
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

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()

    private let codeField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Code provided by your teacher..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()


    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.tag = 2
        
        registerButton.addTarget(self,
                              action: #selector(registerButtonTapped),
                              for: .touchUpInside)
        
        codeField.delegate = self
        backButton.addTarget(self,
                             action: #selector(didTapBack),
                             for: .touchUpInside)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(codeField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(backButton)
        
        imageView.isUserInteractionEnabled = false
        scrollView.isUserInteractionEnabled = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds

        let size = scrollView.width/3
        backButton.frame = CGRect(x: 20,
                                  y: 80,
                                  width: 200,
                                  height: 50)
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: scrollView.height/3,
                                 width: size,
                                 height: size)

        imageView.layer.cornerRadius = imageView.width/2.0

        codeField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        registerButton.frame = CGRect(x: 30,
                                   y: codeField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)

    }
    
    @objc private func didTapBack(){
        popDelegate?.onPopView()
    }
    
    @objc private func registerButtonTapped() {
//        print("tapped")
        codeField.resignFirstResponder()
        guard let code = codeField.text else{
            alertUserInputError()
            return
        }
        
        DatabaseManager.shared.codeRegistered(with: code, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                // the code is already registered by the user -> message
                strongSelf.alertUserInputError()
                return
                
            }
            print("not registered yet")
            DatabaseManager.shared.findUserWithCode(with: code, classCode: self!.classroomCode, completion: {[weak self] found in
                if found {
                    print("success")
                    strongSelf.alerUserSuccess()
                    self?.codeField.text = ""
                }
                else{
                    print("failed: xcode exist")
                    strongSelf.alertUserInputError(message: "Seems like the  code does not exist!")
                    self?.codeField.text = ""
                }
            })
        })
    }
    
    func alertUserInputError(message: String = "Seems like the code was already regsitered by your account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alerUserSuccess(message: String = "The code was successfully registered.") {
        let alert = UIAlertController(title: "Yay",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension teacherRegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == codeField {
            registerButtonTapped()
        }
        return true
    }

}
