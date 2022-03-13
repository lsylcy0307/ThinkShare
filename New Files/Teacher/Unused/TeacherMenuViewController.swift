//
//  TeacherMenuViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/07/31.
//

import UIKit

class TeacherMenuViewController: UIViewController {

    let backgroundView = UIView()
    
    private let baseImage = UIImageView()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 238/255, green: 168/255, blue: 73/255, alpha: 1)
        button.setTitle("Set a New\n\n Harkness Discussion", for: .normal)
//        button.setBackgroundImage(UIImage(named: "buttonColor2"), for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0);
        button.contentHorizontalAlignment = .left
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HiraginoSans-W6", size: 30)
        button.addTarget(self, action: #selector(createButtonTapped),
                              for: .touchUpInside)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 238/255, green: 168/255, blue: 73/255, alpha: 1)
        button.setTitle("Registered Discussions", for: .normal)
//        button.setBackgroundImage(UIImage(named: "buttonColor2"), for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0);
        button.contentHorizontalAlignment = .left
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HiraginoSans-W6", size: 30)
        button.addTarget(self, action: #selector(listButtonTapped),
                              for: .touchUpInside)
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 238/255, green: 168/255, blue: 73/255, alpha: 1)
        button.setTitle("Profile", for: .normal)
//        button.setBackgroundImage(UIImage(named: "buttonColor2"), for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0);
        button.contentHorizontalAlignment = .left
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HiraginoSans-W6", size: 30)
        button.addTarget(self, action: #selector(profileButtonTapped),
                              for: .touchUpInside)
        return button
    }()
    
    private let classButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 238/255, green: 168/255, blue: 73/255, alpha: 1)
        button.setTitle("Class", for: .normal)
//        button.setBackgroundImage(UIImage(named: "buttonColor2"), for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0);
        button.contentHorizontalAlignment = .left
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HiraginoSans-W6", size: 30)
        button.addTarget(self, action: #selector(classButtonTapped),
                              for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseImage.image = UIImage(named: "BaseColor3")
        
        view.addSubview(backgroundView)
        
        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.width, height: view.height))
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = backgroundView.width/2
        createButton.frame = CGRect(x: (backgroundView.frame.size.width-size)/2,
                                    y: view.frame.height/5,
                                 width: size,
                                 height: backgroundView.height*(1/5))
        listButton.frame = CGRect(x: (backgroundView.frame.size.width-size)/2,
                                    y:createButton.bottom+10,
                                 width: size,
                                 height: backgroundView.height*(1/5))
        
        profileButton.frame = CGRect(x: (backgroundView.frame.size.width-size)/2,
                                     y: listButton.bottom+10,
                                 width: size,
                                 height: backgroundView.height*(1/5))
        classButton.frame = CGRect(x: (backgroundView.frame.size.width-size)/2,
                                     y: profileButton.bottom+10,
                                 width: size,
                                 height: backgroundView.height*(1/5))
        
        baseImage.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.size.width, height: backgroundView.frame.size.height)
        
        backgroundView.addSubview(baseImage)
        backgroundView.addSubview(createButton)
        backgroundView.addSubview(listButton)
        backgroundView.addSubview(profileButton)
        backgroundView.addSubview(classButton)
    }
    
    @objc private func createButtonTapped() {
        let vc = CreateDiscussionViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    @objc private func listButtonTapped(){
        let vc = DiscussionListViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    @objc private func classButtonTapped(){
        let vc = classListViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    
    @objc private func profileButtonTapped() {
        let vc = ProfileViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    static func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
}
