//
//  LoadingViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/07/31.
//

import UIKit
import FirebaseAuth

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoader()
    }
    
    private func setLoader(){
        indicator.color = .white
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
        else{
            render()
        }
    }
    
    private func render(){
        print("rendered!")
        
        let identity = UserDefaults.standard.value(forKey: "identity") as? String
        
        DispatchQueue.main.asyncAfter(deadline:.now() + .seconds(1),execute:  {

            if (identity == "Students"){
                print("student")
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                window.rootViewController = ContainerViewController()
                window.makeKeyAndVisible()
//                let vc = ViewRegisteredViewController()
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
//                self.present(nav, animated: true)
            }
            else if (identity == "Teacher"){
                print("teacher")
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                window.rootViewController = TeacherContainerViewController()
                window.makeKeyAndVisible()
            }
            else {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
                self.present(nav, animated: true)
            }
        })
    }
    
}
