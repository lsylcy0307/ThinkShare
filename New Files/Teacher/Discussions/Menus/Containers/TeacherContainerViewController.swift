//
//  TeacherContainerViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/11/30.
//

import UIKit

class TeacherContainerViewController: UIViewController{
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed

    let MenuVC = TeacherMenusViewController()
    var VCTagQueue:[Int] = []
    var ClassVCTagQueue:[Int] = []
    
    var navVC:UINavigationController?
    
    lazy var profileVC = ProfileViewController()
    lazy var HomeVC = DiscussionListViewController()
    lazy var loginVC = LoginViewController()
    lazy var classVC = classListViewController()
    lazy var classListVC = classroomsViewController()
    
    lazy var classDiscVC = classDiscussionViewController()
    lazy var registerVC = teacherRegisterViewController()
    lazy var historyVC = HistoryViewController()
    lazy var viewRegisterVC = teacherViewRegisiteredViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChildVC()
    }
    
    private func addChildVC(){
        
        MenuVC.delegate = self
        //freaking!!!!!
        classListVC.delegate = self
        classDiscVC.delegate = self
        classDiscVC.popDelegate = self
        registerVC.popDelegate = self
        viewRegisterVC.popDelegate = self
        historyVC.popDelegate = self
        
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

extension TeacherContainerViewController: TeacherHomeViewControllerDelegate{

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

extension TeacherContainerViewController: TeacherMenuViewControllerDelegate, loadViewDelegate, popClassVCDelegate{
    
    
    
    
    func didSelect(menuItem: TeacherMenusViewController.MenuOptions) {
//        print("delegate work")
        toggleMenu(completion: nil)
        switch menuItem{
        case .home:
            self.resetToHome()
        case .profile:
            self.addProfile()
        case .info:
            break
        case .classroom:
            self.addClassroom()
        case .classList:
            self.addClassList()
        }
    }
    
    func onLoadView(with info: classrooms?, page: Int) {
        if (page==1){
            let vc = classDiscVC
            //show the menu option for the class
            vc.title = "\(info!.classroom)"
            vc.classInfo = info
//            self.removeVC()
            HomeVC.addChild(vc)
            HomeVC.view.addSubview(vc.view)
            ClassVCTagQueue.append(vc.view.tag)
            vc.view.frame = view.frame
            vc.didMove(toParent: self)
            HomeVC.title = vc.title
        }
        else if (page==2){
            let vc = registerVC
            vc.classroomCode = info?.code
            vc.title = "\(info!.classroom): Register a code"
//            self.removeVC()
            HomeVC.addChild(vc)
            HomeVC.view.addSubview(vc.view)
            ClassVCTagQueue.append(vc.view.tag)
            vc.view.frame = view.frame
            vc.didMove(toParent: self)
            HomeVC.title = vc.title
        }
        else if (page==3){
            let vc = viewRegisterVC
            vc.title = "\(info!.classroom)"
            vc.classInfo = info
//            self.removeVC()
            HomeVC.addChild(vc)
            HomeVC.view.addSubview(vc.view)
            ClassVCTagQueue.append(vc.view.tag)
            vc.view.frame = view.frame
            vc.didMove(toParent: self)
            HomeVC.title = vc.title
        }
        else if (page==4){
            let vc = historyVC
//            vc.sort = "t"
            vc.title = "\(info!.classroom): History"
            vc.classInfo = info
//            self.removeVC()
            HomeVC.addChild(vc)
            HomeVC.view.addSubview(vc.view)
            ClassVCTagQueue.append(vc.view.tag)
            vc.view.frame = view.frame
            vc.didMove(toParent: self)
            HomeVC.title = vc.title
        }
        
    }
    
    func onPopView() {
        print("pressed")
        removeClassVC()
    }
    //did tap back
    func removeClassVC(){
        if ClassVCTagQueue.isEmpty == true {
            return
        }
        else {
            if ClassVCTagQueue.last == 5 {
                classDiscVC.view.removeFromSuperview()
                classDiscVC.didMove(toParent: nil)
            }
            else if ClassVCTagQueue.last == 6 {
                viewRegisterVC.view.removeFromSuperview()
                viewRegisterVC.didMove(toParent: nil)
            }
            else if ClassVCTagQueue.last == 8 {
                historyVC.view.removeFromSuperview()
                historyVC.didMove(toParent: nil)
            }
            else if ClassVCTagQueue.last == 2 {
                registerVC.view.removeFromSuperview()
                registerVC.didMove(toParent: nil)
            }
            ClassVCTagQueue.popLast()
        }
    }
    
    func addClassDisc(){
        let vc = classDiscVC
        self.removeVC()
        HomeVC.addChild(vc)
        HomeVC.view.addSubview(vc.view)
        VCTagQueue.append(vc.view.tag)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        HomeVC.title = vc.title
    }
    
    func addClassList(){
        let vc = classListVC
        self.removeVC()
        HomeVC.addChild(vc)
        HomeVC.view.addSubview(vc.view)
        VCTagQueue.append(vc.view.tag)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        HomeVC.title = vc.title
    }
    
    func addClassroom(){
        let vc = classVC
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
    
    func removeVC(){
        if ClassVCTagQueue.isEmpty != true {
            for tag in ClassVCTagQueue{
                if tag == 2 {
                    registerVC.view.removeFromSuperview()
                    registerVC.didMove(toParent: nil)
                }
                else if tag == 5 {
                    classDiscVC.view.removeFromSuperview()
                    classDiscVC.didMove(toParent: nil)
                }
                else if tag == 6 {
                    viewRegisterVC.view.removeFromSuperview()
                    viewRegisterVC.didMove(toParent: nil)
                }
                else if tag == 8 {
                    historyVC.view.removeFromSuperview()
                    historyVC.didMove(toParent: nil)
                }
            }
            ClassVCTagQueue.removeAll()
        }
        if VCTagQueue.isEmpty == true {
            return
        }
        else {
            if VCTagQueue.last == 1 {
                profileVC.view.removeFromSuperview()
                profileVC.didMove(toParent: nil)
            }
            else if VCTagQueue.last == 3 {
                classVC.view.removeFromSuperview()
                classVC.didMove(toParent: nil)
            }
            else if VCTagQueue.last == 4 {
                classListVC.view.removeFromSuperview()
                classListVC.didMove(toParent: nil)
            }
        }
    }
    
    func resetToHome(){
        self.removeVC()
        HomeVC.title = "Home"
    }
}
