

import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var topicSelected = false
    let image = UIImage(named: "placeholder")
    let infoTitles:[String] = ["What is Harkness?", "Building Ideas", "Textual Evidence"]
    let descriptions:[String] = ["learn about harkness discussion", "learn how to develop your ideas", "learn how to strengthen your idea with evidence"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(infoTableViewCell.self, forCellReuseIdentifier: infoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backButtonPushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
            cell.configure(with: self.image!, title: infoTitles[indexPath.row], description: descriptions[indexPath.row])
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewCell.identifier,for: indexPath) as! infoTableViewCell
            cell.configure(with: self.image!, title: "not set", description: "not yet")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(infoTitles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
