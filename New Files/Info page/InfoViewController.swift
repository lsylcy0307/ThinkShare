

import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var topicSelected = false
    let image = UIImage(named: "placeholder")
    let infoTitles:[String] = ["How to use ThinkShare", "Harkness?", "ThinkShare"]
    let descriptions:[String] = ["learn about harkness discussion", "learn how to develop your ideas", "learn how to strengthen your idea with evidence"]
    
    var VCTagQueue:[Int] = []
    lazy var appUseVC = appUseViewController()
    lazy var harknessVC = harknessViewController()
    lazy var HomeVC = ViewRegisteredViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "App info"
        tableView.register(infoTableViewCell.self, forCellReuseIdentifier: infoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    @IBAction func backButtonPushed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topicSelected == false{
            return infoTitles.count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if topicSelected == false{
            let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewCell.identifier,for: indexPath) as! infoTableViewCell
            cell.configure(with: infoTitles[indexPath.row])
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewCell.identifier,for: indexPath) as! infoTableViewCell
            cell.configure(with: "not set")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(infoTitles[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func addAppUseInfo(){
        let vc = appUseVC
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
                appUseVC.view.removeFromSuperview()
                appUseVC.didMove(toParent: nil)
            }
            else if VCTagQueue.last == 2 {
                harknessVC.view.removeFromSuperview()
                harknessVC.didMove(toParent: nil)
            }
        }
    }
    
    func resetToHome(){
        self.removeVC()
        HomeVC.title = "Home"
    }
}
