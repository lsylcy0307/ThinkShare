

import UIKit

class DiscussionContainerViewController: UIViewController {
    
    var navVC:UINavigationController?
    var selectedModel:registeredSetting?
    
    lazy var createVC = createGroupViewController()
    lazy var participantsVC = ParticipantsViewController()
    lazy var discussonVC = DiscussionViewController()
    lazy var resultVC = ResultViewController()
    lazy var testVC = testViewController()
    
    init(model: registeredSetting) {
            self.selectedModel = model
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addChildVC()
    }
    
    private func addChildVC(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let discussionVC = storyBoard.instantiateViewController(withIdentifier: "createView") as! createGroupViewController
        discussionVC.setting = self.selectedModel
        discussionVC.title = selectedModel?.code
        
        let navVC = UINavigationController(rootViewController: discussionVC)
        navVC.view.frame.size = self.view.frame.size
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        navVC.title = self.selectedModel?.code
    }
}
