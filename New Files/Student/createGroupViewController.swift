//
//  createGroupViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/07/31.
//

import UIKit

class createGroupViewController: UIViewController {
    
    var student_names = [String]()
    
    var setting:registeredSetting?
    
    private var discussion_id = ""
    
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var numBoysField: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var n1: UITextField!
    @IBOutlet weak var n2: UITextField!
    @IBOutlet weak var n3: UITextField!
    @IBOutlet weak var n4: UITextField!
    @IBOutlet weak var n5: UITextField!
    
    @IBOutlet weak var n6: UITextField!
    @IBOutlet weak var n7: UITextField!
    @IBOutlet weak var n8: UITextField!
    @IBOutlet weak var n9: UITextField!
    @IBOutlet weak var n10: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        numBoysField.isUserInteractionEnabled = false
        
        backBtn.layer.cornerRadius = 12
        continueBtn.layer.cornerRadius = 12
        
        continueBtn.isEnabled = false
        
        [groupNameField, numBoysField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @IBAction func backTapped(_ sender: Any) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        window.rootViewController = ContainerViewController()
        window.makeKeyAndVisible()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        print("continue tapped")
        save()
        
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        numBoysField.text = Int(sender.value).description
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let group = groupNameField.text, !group.isEmpty,
            let boy = numBoysField.text, !boy.isEmpty
        //     let frequency = frequencyField.text, !frequency.isEmpty
        else {
            continueBtn.isEnabled = false
            return
        }
        continueBtn.isEnabled = true
    }
    
    func alertCreateError(message: String = "Please enter all information to create a new discussion.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func save(){
        student_names = [n1.text!, n2.text!, n3.text!, n4.text!, n5.text!, n6.text!, n7.text!, n8.text!, n9.text!, n10.text!]
        guard let groupName = groupNameField.text,
              let student_num = Int(numBoysField.text!) else {return}
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "ParticipantsView") as! ParticipantsViewController
        mainViewController.participant = Int(numBoysField.text!)
        mainViewController.partNames = self.student_names
        mainViewController.setting = setting
        mainViewController.num_students = student_num
        mainViewController.groupName = groupName
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
