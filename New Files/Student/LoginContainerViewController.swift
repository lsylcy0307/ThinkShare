

import UIKit

class LoginContainerViewController: UIViewController {
    
    var navVC:UINavigationController?
    
    lazy var loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addChildVC()
    }
    
    private func addChildVC(){
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let discussionVC = storyBoard.instantiateViewController(withIdentifier: "createView") as! createGroupViewController
//        discussionVC.setting = self.selectedModel
//        discussionVC.title = selectedModel?.code
        
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.view.frame.size = self.view.frame.size
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        navVC.title = "login"
    }
}
