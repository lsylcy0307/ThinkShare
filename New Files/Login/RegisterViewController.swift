import UIKit
import FirebaseAuth
import DropDown
//import JGProgressHUD

final class RegisterViewController: UIViewController {

//    private let spinner = JGProgressHUD(style: .dark)

    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Teacher", "Students"]
        return menu
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
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
    
    lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to ThinkShare"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 55)
        label.textColor = .black
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Opening up for a discussion."
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        label.textColor = .gray
        return label
    }()

    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()

    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
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
        field.backgroundColor = .white
        return field
    }()
    
    private let identityField: UILabel = {
        let field = UILabel()
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.text = "Are you a..."
        field.backgroundColor = .white
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
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

    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("CREATE →", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 252/255, green: 197/255, blue: 0/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .systemBackground

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
//                                                            style: .done,
//                                                            target: self,
//                                                            action: #selector(didTapRegister))

//        registerButton.addTarget(self,
//                              action: #selector(registerButtonTapped),
//                              for: .touchUpInside)

        emailField.delegate = self
        passwordField.delegate = self

        // Add subviews
        view.addSubview(scrollView)
//        scrollView.addSubview(imageView)
        scrollView.addSubview(registerLabel)
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(identityField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)

        imageView.isUserInteractionEnabled = false
        scrollView.isUserInteractionEnabled = true
        
        menu.anchorView = identityField
      
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapIdentitySet))
        self.identityField.isUserInteractionEnabled = true
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        identityField.addGestureRecognizer(gesture)
        
        menu.selectionAction = { index, title in
            print("index \(index) and \(title)")
            self.identityField.text = title
        }
    }
    
    @objc func didTapIdentitySet(){
        print("tapped")
        menu.show()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        registerLabel.frame = CGRect(x: (view.frame.size.width-250)/4, y: view.frame.size.height/6, width: 650, height: 80)
        
        infoLabel.frame = CGRect(x:  (view.frame.size.width-250)/4, y: registerLabel.bottom+10, width: 500, height: 30)

        firstNameField.frame = CGRect(x:  (view.frame.size.width-250)/4,
                                  y: infoLabel.bottom+15,
                                  width: registerLabel.width,
                                  height: 52)
        lastNameField.frame = CGRect(x:  (view.frame.size.width-250)/4,
                                  y: firstNameField.bottom+10,
                                  width: registerLabel.width,
                                  height: 52)
        emailField.frame = CGRect(x:  (view.frame.size.width-250)/4,
                                  y: lastNameField.bottom+10,
                                  width: registerLabel.width,
                                  height: 52)
        passwordField.frame = CGRect(x:  (view.frame.size.width-250)/4,
                                     y: emailField.bottom+10,
                                     width: registerLabel.width,
                                     height: 52)
        identityField.frame = CGRect(x:  (view.frame.size.width-250)/4,
                                     y: passwordField.bottom+10,
                                     width: registerLabel.width,
                                     height: 52)
        registerButton.frame = CGRect(x: identityField.right - 180,
                                   y: identityField.bottom+10,
                                   width: 180,
                                   height: 52)
        

    }

    @objc private func registerButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()

        guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let identity = identityField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !password.isEmpty,
            !identity.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            password.count >= 6 else {
                alertUserLoginError()
                return
        }

//        spinner.show(in: view)

        // Firebase Log In
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }

//            DispatchQueue.main.async {
//                strongSelf.spinner.dismiss()
//            }

            guard !exists else {
                // user already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }

            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error cureating user")
                    return
                }

                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue(identity, forKey: "identity")
                UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")


                let chatUser = HarknessAppUser(firstName: firstName,
                                          lastName: lastName,
                                          emailAddress: email,
                                          identity: identity)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        print("inserted new user")
                    }
                })
                guard let identity = UserDefaults.standard.value(forKey: "identity") as? String else {
                    return
                }
                guard let strongSelf = self else{
                    return
                }
                if (identity == "Students"){
                    let vc = MenusViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
                    strongSelf.present(nav, animated: true)
                }
                else if (identity == "Teacher"){
                    let vc = TeacherMenuViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
                    strongSelf.present(nav, animated: true)
                }
                
            })
        })
    }

    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }

        return true
    }

}
