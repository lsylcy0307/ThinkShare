//
//  ProfileViewController.swift
//  allergendetect
//
//  Created by Su Yeon Lee on 2021/01/20.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var detectObserver: NSObjectProtocol?
    
    let data = ["Log out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.tag = 1
        view.backgroundColor = .white
        view.addSubview(tableView)
        detectObserver = NotificationCenter.default.addObserver(forName: .myNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else{
                return
            }
            strongSelf.doWhenNotified()
            
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    deinit{
        if let observer = detectObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func doWhenNotified() {
        print("received notification")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //getting email directory in fb resources
    func createTableHeader() -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.width,
                                              height: 300))
        
        headerView.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 157/255, alpha: 1)
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)
        imageView.image = UIImage(named: "Girl")
        
        return headerView
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //unhighlight the cell
        
        print("logout")
        //log out google
        GIDSignIn.sharedInstance()?.signOut()
        
        do{

            try FirebaseAuth.Auth.auth().signOut()

            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
            self.present(nav, animated: true)

        }
        catch{
            print("failed to logout")
        }
                //alert before logout
//
//        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {[weak self] _ in
//            guard let strongSelf = self else{
//                return
//            }
//            //log out google
//            GIDSignIn.sharedInstance()?.signOut()
//
//            do{
//
//                try FirebaseAuth.Auth.auth().signOut()
//
//                let vc = LoginViewController()
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen //don't want user to dismiss the login page
//                strongSelf.present(nav, animated: true)
//
//            }
//            catch{
//                print("failed to logout")
//            }
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(actionSheet, animated: true)
    }
}
