//
//  TopicPoppingViewController.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/07/01.
//

import UIKit
import FirebaseFirestore
import JGProgressHUD

class TopicPoppingViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    
    var setting:registeredSetting?
    
    private var texts = [String]()
    private var questions = [[String]]()
    private var textLinks = [String]()
    
    @IBOutlet var popView: UIView!
    @IBOutlet weak var backBtn: UIButton!

    private var selectedIdx = 0
    private var hasFetchedText = false
    private var textSelected = false
    private var selectedText = String()
    
    private let textLinkButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("Click for the Text", for: .normal)
//        button.backgroundColor = UIColor(red: 238/255, green: 168/255, blue: 73/255, alpha: 1)
        button.setBackgroundImage(UIImage(named: "buttonColor2"), for: .normal)
        button.contentMode = .scaleToFill
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: "HiraginoSans-W6", size: 25)
        button.layer.masksToBounds = true
        return button
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !textSelected{
            backBtn.isHidden = true
        }
        (textLinkButton).addTarget(self,
                              action: #selector(textLinkTapped),
                              for: .touchUpInside)
        
        view.addSubview(textLinkButton)
        
        collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.loadTexts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        textLinkButton.frame = CGRect(x: (view.frame.size.width-size)/2,
                                   y: view.height/2,
                                   width: size,
                                   height: 70)
    }
    
    @objc private func textLinkTapped() {
        openUrl(urlStr: textLinks[selectedIdx])
        NotificationCenter.default.post(name: DiscussionViewController.topicNotification, object: nil, userInfo: ["slctIdx": selectedIdx, "slctTxt":texts[selectedIdx], "slctLink":textLinks[selectedIdx], "slctQuestions":questions[selectedIdx]])
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func backBtnPushed(_ sender: Any) {
        textSelected = false
        backBtn.isHidden = true
        self.collectionView.reloadData()
    }
    
    func loadTexts(){
        spinner.show(in: view)
        
        guard let registerdSetting = setting else {return}
        DatabaseManager.shared.loadSettings(with: registerdSetting, completion: {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            switch result {
            case.success(let texts):
                print("successfully got")
                self?.sortData(with: texts)
            case .failure(_):
                print("failed to get texts")
            }
        })
        
    }
    
    private func sortData(with textData:[[String:Any]]){
        for text in textData{
            texts.append(text["textName"] as! String)
            questions.append(text["questions"] as! [String])
            textLinks.append(text["textLink"] as! String)
        }
        TexttoView()
    }
    
    func openUrl(urlStr: String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func TexttoView(){
        if hasFetchedText {
            print("already loaded")
        }
        else{
            self.collectionView.reloadData()
        }
    }
    
    func loadLink(){
        textLinkButton.isHidden = false
    }

}

extension TopicPoppingViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        if textSelected == false {
            textLinkButton.isHidden = true
            selectedText = texts[indexPath.row]
            selectedIdx = indexPath.row
            print("selectedIdx: \(selectedIdx)")
            print("clicked: \(selectedText)")
            textSelected = true
            self.loadLink()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if textSelected == false {
            return texts.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! topicsCollectionViewCell
        if textSelected == false {
            Cell.configure(with: texts[indexPath.row])
            return Cell
        }
        else {
            return Cell
        }
    }
}
