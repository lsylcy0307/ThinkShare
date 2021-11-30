//
//  TeacherMenusViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/11/30.
//

import UIKit

protocol TeacherMenuViewControllerDelegate:AnyObject {
    func didSelect(menuItem: TeacherMenusViewController.MenuOptions)
}

class TeacherMenusViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    weak var delegate:TeacherMenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case register = "Create"
        case profile = "Profile"
        case info = "Information"
        
        var imageName: String{
            switch self {
            case .home:
                return "house"
            case .profile:
                return "person"
            case .info:
                return "gear"
            case .register:
                return "airplane"
            }
        }
    }

    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 0.2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.backgroundColor = .gray
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = .white
        cell.contentView.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }

}
