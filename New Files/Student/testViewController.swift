//
//  testViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/09/17.
//

import UIKit

class testViewController: UIViewController {
    
    var receive:registeredSetting?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(TapMenuButton))
        
    }
    @objc func TapMenuButton(){
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        window.rootViewController = ContainerViewController()
        window.makeKeyAndVisible()
    }
    
    

}
