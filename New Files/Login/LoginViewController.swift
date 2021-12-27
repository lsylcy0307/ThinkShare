//
//  LoginViewController.swift
//  allergendetect
//
//  Created by Su Yeon Lee on 2021/01/20.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 55)
        label.textColor = .black
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please login to continue."
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        label.textColor = .gray
        return label
    }()
    
    lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        label.font = UIFont(name: "NotoSansKannada", size: 20)
        label.textColor = .gray
        return label
    }()

    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 252/255, green: 197/255, blue: 0/255, alpha: 1), for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        return button
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "thinkshare-logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let appLabel: UILabel = {
            let label = UILabel()
            label.text = "ThinkShare"
            label.textAlignment = .center
            label.textColor = .systemPurple
            label.font = .systemFont(ofSize: 50, weight: .thin)
            return label
        }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN →", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    private var loginObserver:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //leverage notification  - way app delegate can fire notification and anything that listens it can take action
        //.didLogInNotification -> extension. swift (handling string more carefully)
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification ,object: nil, queue: .main, using: {_ in
            
            
            guard let identity = UserDefaults.standard.value(forKey: "identity") as? String else {
                return
           }
            if (identity == "Students"){
                print("student")
                
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                window.rootViewController = ContainerViewController()
                window.makeKeyAndVisible()

            }
            else if (identity == "Teacher"){
                
                print("teacher")
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                window.rootViewController = TeacherContainerViewController()
                window.makeKeyAndVisible()

            }
        })
        //once controller dismisses, want to get rid of observation (for memory)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        title = "log in"
        view.backgroundColor = .white
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        //add target to a button
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                              action: #selector(didTapRegister),
                              for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(loginLabel)
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerLabel)
        scrollView.addSubview(registerButton)
    }
    //dimiss observer
    deinit {
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
//        let size = scrollView.width/4
//        imageView.frame = CGRect(x: (view.frame.size.width-size)/2,
//                                 y: scrollView.height/4,
//                                 width: size,
//                                 height: size)
        loginLabel.frame = CGRect(x: view.frame.size.width/4, y: view.frame.size.height/4, width: 300, height: 80)
        infoLabel.frame = CGRect(x: view.frame.size.width/4, y: loginLabel.bottom+10, width: 300, height: 30)
        emailField.frame = CGRect(x: view.frame.size.width/4,
                                  y: infoLabel.bottom+30,
                                  width: scrollView.width/2,
                                  height: 52)
        passwordField.frame = CGRect(x: view.frame.size.width/4,
                                     y: emailField.bottom+10,
                                     width: scrollView.width/2,
                                     height: 52)
        loginButton.frame = CGRect(x: passwordField.right - 180,
                                   y: passwordField.bottom+10,
                                   width: 180,
                                   height: 52)
        registerLabel.frame = CGRect(x: (view.frame.size.width-313)/2,
                                   y: loginButton.bottom+100,
                                   width: 180,
                                   height: 30)
        registerButton.frame = CGRect(x: registerLabel.right + 1,
                                   y: loginButton.bottom+102,
                                   width: 110,
                                   height: 30)
        
    }
    
    @objc private func loginButtonTapped() {
        
        //dismiss the keyboard
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError() //password requirement
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        DatabaseManager.shared.isTeacher(with: safeEmail, completion: { teacher in
            if teacher {
                UserDefaults.standard.setValue("Teacher", forKey: "identity")
            }
            else{
                UserDefaults.standard.setValue("Students", forKey: "identity")
            }
        })
        spinner.show(in: view)
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authResult, error == nil else{
                print("failed to log in user")
                return
            }
            
            let user = result.user
            //save email
            UserDefaults.standard.set(email, forKey: "email")
            print("logged in user \(user)")
            
            if (UserDefaults.standard.value(forKey: "identity") as! String == "Students") {
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                window.rootViewController = ContainerViewController()
                window.makeKeyAndVisible()
            }
            else {
                print("load to a teacher page")
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                window.rootViewController = TeacherContainerViewController()
                window.makeKeyAndVisible()
            }
            
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension LoginViewController: UITextFieldDelegate{
    //called when the user hits a return key, move to the next box
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField==passwordField{
            loginButtonTapped()
        }
        return true
    }
}


