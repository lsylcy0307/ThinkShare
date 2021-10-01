//
//  ContainerViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/09/15.
//

import UIKit

class ContainerViewController: UIViewController {

    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed

    let MenuVC = MenuViewController()
    var VCTagQueue:[Int] = []
    
    var navVC:UINavigationController?
    
    lazy var profileVC = ProfileViewController()
    lazy var registerVC = RegisterSettingViewController()
    lazy var HomeVC = ViewRegisteredViewController()
    lazy var HistoryVC = HistoryViewController()
    lazy var loginVC = LoginViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addChildVC()
    }
    
    private func addChildVC(){
        
        MenuVC.delegate = self
        
        addChild(MenuVC)
        view.addSubview(MenuVC.view)
        MenuVC.didMove(toParent: self)
        
        self.HomeVC.delegate = self
        let navVC = UINavigationController(rootViewController: HomeVC)
        navVC.view.frame.size = self.view.frame.size
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
    

}

extension ContainerViewController: HomeViewControllerDelegate {

    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?){
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut){
                self.navVC?.view.frame.origin.x = self.HomeVC.view.frame.size.width / 3
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut){
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }

}

extension ContainerViewController: menuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem{
        case .home:
            self.resetToHome()
        case .profile:
            self.addProfile()
        case .history:
            self.addHistory()
        case .info:
            break
        case .register:
            self.addRegister()
        }
    }
    
    
    func addRegister(){
        let vc = registerVC
        self.removeVC()
        HomeVC.addChild(vc)
        HomeVC.view.addSubview(vc.view)
        VCTagQueue.append(vc.view.tag)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        HomeVC.title = vc.title
    }
    
    func addProfile(){
        let vc = profileVC
        self.removeVC()
        HomeVC.addChild(vc)
        HomeVC.view.addSubview(vc.view)
        VCTagQueue.append(vc.view.tag)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        HomeVC.title = vc.title
    }
    
    func addHistory(){
        let vc = HistoryVC
        self.removeVC()
        HomeVC.addChild(vc)
        HomeVC.view.addSubview(vc.view)
        VCTagQueue.append(vc.view.tag)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        HomeVC.title = vc.title
    }
    
    func removeVC(){
        if VCTagQueue.isEmpty == true {
            return
        }
        else {
            if VCTagQueue.last == 1 {
                profileVC.view.removeFromSuperview()
                profileVC.didMove(toParent: nil)
            }
            else if VCTagQueue.last == 2 {
                registerVC.view.removeFromSuperview()
                registerVC.didMove(toParent: nil)
            }
            else if VCTagQueue.last == 3 {
                HistoryVC.view.removeFromSuperview()
                HistoryVC.didMove(toParent: nil)
            }
        }
    }
    
    func resetToHome(){
        self.removeVC()
        HomeVC.title = "Home"
    }
}


