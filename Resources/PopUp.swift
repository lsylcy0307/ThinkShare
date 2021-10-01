//
//  PopUp.swift
//  launchxGroup6
//
//  Created by Su Yeon Lee on 2021/07/11.
//

import UIKit

protocol PopUpDelegate {
    func onResponseReady(responseType: Int)
}

class PopUp: UIView {
    
    var delegate: PopUpDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.font = UIFont(name: "PingFangHK-Semibold", size: 45)
        label.text = "Choose a Type of Your Response"
        return label
    }()
    
//    var response1View = UIView()
//    var response2View = UIView()
//    var response3View = UIView()
//    var response4View = UIView()
//    var titleView = UIView()
    
    var selectedResponse = 0
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.font = UIFont(name: "PingFangHK-Semibold", size: 30)
        label.textColor = UIColor(red: 195/255, green: 102/255, blue: 89/255, alpha: 1)
        label.text = "Listening..."
        return label
    }()
    
    let rsp1Btn: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "agreement.png"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleResp1), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.layer.cornerRadius = 5
        return button
    }() //handle responses
    
    let rsp2Btn: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "disagreement.png"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleResp2), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    let rsp3Btn: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "elaboration.png"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleResp3), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.layer.cornerRadius = 5
        return button
    }()

    let rsp4Btn: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "change.png"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleResp4), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .white
        
        [titleLabel, rsp1Btn, rsp2Btn, rsp3Btn, rsp4Btn].forEach{ addSubview($0) }
        
        rsp1Btn.rightAnchor.constraint(equalTo: rsp2Btn.leftAnchor, constant: -20).isActive = true
        rsp1Btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rsp1Btn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        rsp1Btn.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        rsp2Btn.rightAnchor.constraint(equalTo: centerXAnchor, constant: -10).isActive = true
        rsp2Btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rsp2Btn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        rsp2Btn.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        rsp3Btn.leftAnchor.constraint(equalTo: centerXAnchor, constant: 10).isActive = true
        rsp3Btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rsp3Btn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        rsp3Btn.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        rsp4Btn.leftAnchor.constraint(equalTo: rsp3Btn.rightAnchor, constant: 20).isActive = true
        rsp4Btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rsp4Btn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        rsp4Btn.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: rsp1Btn.topAnchor, constant: -20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    }
    
    required init?(coder aDecoder:NSCoder) {
        fatalError("init has not been implemented")
    }
    
    private func handlePopUp(){
        delegate?.onResponseReady(responseType: selectedResponse)
    }
    
    @objc func handleResp1(){
        //agree
        selectedResponse = 1
        handlePopUp()
    }
    
    @objc func handleResp2(){
        //disagree
        selectedResponse = 2
        handlePopUp()
    }
    
    @objc func handleResp3(){
        //elaboration
        selectedResponse = 3
        handlePopUp()
    }
    
    @objc func handleResp4(){
        //change
        selectedResponse = 4
        handlePopUp()
    }
}

