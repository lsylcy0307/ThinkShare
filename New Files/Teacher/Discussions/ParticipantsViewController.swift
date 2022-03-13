import UIKit
import JGProgressHUD
 
class ParticipantsViewController: UIViewController{
    private let spinner = JGProgressHUD(style: .dark)
//    public var sort = ""
    public var classroomCode = ""
    private var discussion_id = ""
    
    private var texts = [String]()
    private var criterias = [[String]]()
    private var questions = [[String]]()
    private var textLinks = [String]()
    
    //tableSettings
    
    public var setting:registeredSetting?
    public var modeSwitch = false
    public var num_students = 0 //number of participants
    public var groupName = ""
    //-----
    var totalParticipants:Int?
    var participant:Int?
    var images: [UIImage] = []
    var originalImg: [UIImage] = []
    var userIndex:[Int] = []
    var selectedFinger = 0
    var disucssionTable:[Int] = []
    var nameSetting:[String] = []
    var count = 0
    var names:[String] = []
    @IBOutlet weak var whiteView: UIImageView!
    
    var partNames:[String?] = []
    public var selectedIndex = 0
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var name5: UILabel!
    @IBOutlet weak var name6: UILabel!
    @IBOutlet weak var name7: UILabel!
    @IBOutlet weak var name8: UILabel!
    @IBOutlet weak var name9: UILabel!
    @IBOutlet weak var name10: UILabel!
    @IBOutlet weak var name11: UILabel!
    @IBOutlet weak var name12: UILabel!
    @IBOutlet weak var name13: UILabel!
    @IBOutlet weak var name14: UILabel!
    @IBOutlet weak var name15: UILabel!
    @IBOutlet weak var name16: UILabel!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var sixthImageView: UIImageView!
    @IBOutlet weak var seventhImageView: UIImageView!
    @IBOutlet weak var eightImageView: UIImageView!
    @IBOutlet weak var nighImageView: UIImageView!
    @IBOutlet weak var tenImageView: UIImageView!
    @IBOutlet weak var elevenImageView: UIImageView!
    @IBOutlet weak var twelveImageView: UIImageView!
    @IBOutlet weak var thirteenImageView: UIImageView!
    @IBOutlet weak var sixteenImageView: UIImageView!
    @IBOutlet weak var fifteenImageView: UIImageView!
    @IBOutlet weak var fourteenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(modeSwitch)
        view.backgroundColor = .white
        title = "Set the table"
        continueBtn.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        
        collectionView.layer.cornerRadius = 10
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = CGColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 0.7)
        
//        continueBtn.layer.cornerRadius = 12
//        backBtn.layer.cornerRadius = 12
        
        continueBtn.isEnabled = false
        count = 0
        
        guard let participants = participant else {return}
 
        for i in 1...participants {
            images.append(UIImage(named: "boy-icon")!)
            originalImg.append(UIImage(named: "boy-icon")!)
            names.append(partNames[i-1]!)
            userIndex.append(count)
            count+=1
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height:60)
        collectionView.collectionViewLayout = layout //adjust cell size
        
        collectionView.register(ParticipantCollectionViewCell.nib(), forCellWithReuseIdentifier: ParticipantCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.setDragAndDropSettings()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDragAndDropSettings(){
        let dragInteraction1 = UIDragInteraction(delegate: self)
        dragInteraction1.isEnabled = true
        
        let dragInteraction2 = UIDragInteraction(delegate: self)
        dragInteraction2.isEnabled = true
        
        let dragInteraction3 = UIDragInteraction(delegate: self)
        dragInteraction3.isEnabled = true
        
        let dragInteraction4 = UIDragInteraction(delegate: self)
        dragInteraction4.isEnabled = true
        
        let dragInteraction5 = UIDragInteraction(delegate: self)
        dragInteraction5.isEnabled = true
        
        let dragInteraction6 = UIDragInteraction(delegate: self)
        dragInteraction6.isEnabled = true
        
        let dragInteraction7 = UIDragInteraction(delegate: self)
        dragInteraction7.isEnabled = true
        
        let dragInteraction8 = UIDragInteraction(delegate: self)
        dragInteraction8.isEnabled = true
        
        
        let dropInteraction1 = UIDropInteraction(delegate: self)
        let dropInteraction2 = UIDropInteraction(delegate: self)
        let dropInteraction3 = UIDropInteraction(delegate: self)
        let dropInteraction4 = UIDropInteraction(delegate: self)
        let dropInteraction5 = UIDropInteraction(delegate: self)
        let dropInteraction6 = UIDropInteraction(delegate: self)
        let dropInteraction7 = UIDropInteraction(delegate: self)
        let dropInteraction8 = UIDropInteraction(delegate: self)
        let dropInteraction9 = UIDropInteraction(delegate: self)
        let dropInteraction10 = UIDropInteraction(delegate: self)
        let dropInteraction11 = UIDropInteraction(delegate: self)
        let dropInteraction12 = UIDropInteraction(delegate: self)
        let dropInteraction13 = UIDropInteraction(delegate: self)
        let dropInteraction14 = UIDropInteraction(delegate: self)
        let dropInteraction15 = UIDropInteraction(delegate: self)
        let dropInteraction16 = UIDropInteraction(delegate: self)
        
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        
        firstImageView.isUserInteractionEnabled = true
        secondImageView.isUserInteractionEnabled = true
        thirdImageView.isUserInteractionEnabled = true
        fourthImageView.isUserInteractionEnabled = true
        fifthImageView.isUserInteractionEnabled = true
        sixthImageView.isUserInteractionEnabled = true
        seventhImageView.isUserInteractionEnabled = true
        eightImageView.isUserInteractionEnabled = true
        nighImageView.isUserInteractionEnabled = true
        tenImageView.isUserInteractionEnabled = true
        elevenImageView.isUserInteractionEnabled = true
        twelveImageView.isUserInteractionEnabled = true
        thirteenImageView.isUserInteractionEnabled = true
        sixteenImageView.isUserInteractionEnabled = true
        fifteenImageView.isUserInteractionEnabled = true
        fourteenImageView.isUserInteractionEnabled = true
        
        self.view.isUserInteractionEnabled = true
        
        firstImageView.addInteraction(dropInteraction1)
        secondImageView.addInteraction(dropInteraction2)
        thirdImageView.addInteraction(dropInteraction3)
        fourthImageView.addInteraction(dropInteraction4)
        fifthImageView.addInteraction(dropInteraction5)
        sixthImageView.addInteraction(dropInteraction6)
        seventhImageView.addInteraction(dropInteraction7)
        eightImageView.addInteraction(dropInteraction8)
        nighImageView.addInteraction(dropInteraction9)
        tenImageView.addInteraction(dropInteraction10)
        elevenImageView.addInteraction(dropInteraction11)
        twelveImageView.addInteraction(dropInteraction12)
        thirteenImageView.addInteraction(dropInteraction13)
        sixteenImageView.addInteraction(dropInteraction16)
        fifteenImageView.addInteraction(dropInteraction15)
        fourteenImageView.addInteraction(dropInteraction14)
    }
    
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else{
            return
        }
        
        switch gesture.state{
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in:collectionView)) else{
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc private func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func didTapContinue() {
        spinner.show(in: view)
        guard let registeredSetting = setting else {return}
        
        DatabaseManager.shared.createNewDiscussionGroup(with: registeredSetting.code, teacherName: registeredSetting.teacherName, teacherEmail: registeredSetting.teacherEmail, num_students: num_students, groupName: groupName, tableSetting: disucssionTable, nameSetting:nameSetting, classCode: classroomCode , completion: { [weak self] result in
            switch result {
            case .success(let discussionId):
                self?.discussion_id = discussionId
                self?.getSettings()
                print(discussionId)
            case .failure(let error):
                print("Failed to get the discussion id: \(error)")
            }
        })
    }
    
    private func getSettings(){
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
            print(text)
            criterias.append(text["criterias"] as! [String])
            texts.append(text["textName"] as! String)
            questions.append(text["questions"] as! [String])
            textLinks.append(text["textLink"] as! String)
        }
        self.changeVC()
    }
    
    private func changeVC(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "discussionFlowView") as! DiscussionViewController
        
        mainViewController.classroomCode = classroomCode
        mainViewController.setting = setting
        mainViewController.tableSetting = disucssionTable
        mainViewController.names = nameSetting
        
        mainViewController.send_texts = texts
        mainViewController.send_criterias = criterias
        mainViewController.send_questions = questions
        mainViewController.send_textLinks = textLinks
        
        mainViewController.discussionId = discussion_id
        mainViewController.modeSwitch = modeSwitch
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
}
extension ParticipantsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me")
    }
}
extension ParticipantsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCollectionViewCell.identifier, for: indexPath) as! ParticipantCollectionViewCell
        cell.configure(with: images[indexPath.row], name: names[indexPath.row])
        return cell
    }
    
}
 
extension ParticipantsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 75, height:95)
    }
    
}
 
extension ParticipantsViewController : UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let imageView = interaction.view as? UIImageView{
            guard let image = imageView.image else {return []}
            let provider = NSItemProvider(object: image)
            let item = UIDragItem.init(itemProvider: provider)
            return[item]
        }
        return []
    }
}
 
extension ParticipantsViewController : UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.images[indexPath.row]
                let itemProvider = NSItemProvider(object: item as UIImage)
                let dragItem = UIDragItem(itemProvider: itemProvider)
                dragItem.localObject = item
                selectedFinger = indexPath.row + 1
                selectedIndex = indexPath.row
                print(selectedIndex)
                return [dragItem]
    }
    
}
 
extension ParticipantsViewController : UIDropInteractionDelegate{
    //To Highlight whether the dragging item can drop in the specific area
    //which image in which image view
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let location = session.location(in: self.view)
        let dropOperation: UIDropOperation?
        if session.canLoadObjects(ofClass: UIImage.self) {
            if  firstImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 1
            } else if  secondImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 2
                
            } else if  thirdImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 3
                
            } else if  fourthImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 4
                
            } else if  fifthImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 5
                
            }else if  sixthImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 6
                
            }
            else if  seventhImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 7
                
            }
            else if  eightImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 8
            }
            else if  nighImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 9
            }
            else if  tenImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 10
            }
            else if  elevenImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 11
            }
            else if  twelveImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 12
            }
            else if  thirteenImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 13
            }
            else if  fourteenImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 14
            }
            else if  fifteenImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 15
            }
            else if  sixteenImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 16
            }
            
            else {
                dropOperation = .cancel
                selectedFinger = 0
            }
        } else {
            dropOperation = .cancel
            selectedFinger = 0
        }
        return UIDropProposal(operation: dropOperation!)
    }
    
    //Drop the drag item and handle accordingly
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if session.canLoadObjects(ofClass: UIImage.self) {
            session.loadObjects(ofClass: UIImage.self) { (items) in
                print("drop")
                print(self.names)
                if let images = items as? [UIImage] {
                    switch self.selectedFinger{
                    case 1 :
                        self.firstImageView.image = images.last
                        self.name1.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(1)
                        break
                    case 2 :
                        self.secondImageView.image = images.last
                        self.name2.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(2)
                        break
                    case 3 :
                        self.thirdImageView.image = images.last
                        self.name3.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(3)
                        break
                    case 4 :
                        self.fourthImageView.image = images.last
                        self.name4.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(4)
                        break
                        
                    case 5 :
                        self.fifthImageView.image = images.last
                        self.name5.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(5)
                        break
                    case 6 :
                        self.sixthImageView.image = images.last
                        self.name6.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(6)
                        break
                    case 7 :
                        self.seventhImageView.image = images.last
                        self.name7.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(7)
                        break
                    case 8 :
                        self.eightImageView.image = images.last
                        self.name8.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(8)
                        break
                    case 9 :
                        self.nighImageView.image = images.last
                        self.name9.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(9)
                        break
                    case 10 :
                        self.tenImageView.image = images.last
                        self.name10.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(10)
                        break
                    case 11 :
                        self.elevenImageView.image = images.last
                        self.name11.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(11)
                        break
                    case 12 :
                        self.twelveImageView.image = images.last
                        self.name12.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(12)
                        break
                    case 13 :
                        self.thirteenImageView.image = images.last
                        self.name13.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(13)
                        break
                    case 14 :
                        self.fourteenImageView.image = images.last
                        self.name14.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(14)
                        break
                    case 15 :
                        self.fifteenImageView.image = images.last
                        self.name15.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(15)
                        break
                    case 16 :
                        self.sixteenImageView.image = images.last
                        self.name16.text = self.names[self.selectedIndex]
                        self.nameSetting.append(self.names[self.selectedIndex])
                        self.disucssionTable.append(16)
                        break
                    default:
                        print("exit")
                    }
                    self.images.remove(at: self.selectedIndex)
                    self.names.remove(at: self.selectedIndex)
                    let myIndexPath = IndexPath(row: self.selectedIndex, section: 0)
                    self.collectionView.deleteItems(at: [myIndexPath])
                    self.collectionView.reloadData()
                    if(self.images.count == 0){
                        self.continueBtn.isEnabled = true
                    }
                    else{
                        self.continueBtn.isEnabled = false
                    }
                }
                    
            }
        }
        
    }
}

