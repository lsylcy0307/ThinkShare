//
//  classListViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/02/15.
//

import UIKit

class classListViewController: UIViewController {

    private let classCreateButton: UIButton = {
        let button = UIButton()
        button.setTitle("create class →", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "classroom"
        view.backgroundColor = .white
        view.tag = 3
        classCreateButton.addTarget(self,
                              action: #selector(createButtonTapped),
                              for: .touchUpInside)
        
        view.addSubview(classCreateButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        classCreateButton.frame = CGRect(x: view.frame.size.width/4,
                                   y: view.frame.size.height/4,
                                   width: 180,
                                   height: 52)
    }
    
    
    @objc private func createButtonTapped() {
        let vc = createClassViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
    }


}
