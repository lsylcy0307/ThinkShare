//
//  DiscussionViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/07/31.
//

import UIKit
import AVFoundation
import JGProgressHUD

struct questionSet {
    let question : String
    let duration : Int
}

class DiscussionViewController: UIViewController, AVAudioRecorderDelegate {
    
//    public var sort = ""
    public var send_texts = [String]()
    public var send_criterias = [[String]]()
    public var send_questions = [[String]]()
    public var send_textLinks = [String]()
    
    public var setting:registeredSetting?
    private let spinner = JGProgressHUD(style: .dark)
    public var discussionId = ""
    public var selectedCode = ""
    private var textSelected = false
    private var initialQuestionPop = false
    private var registeredQuestions = [String]()
    public var modeSwitch = false
    
    var lineCnt = 0
    var classroomCode = ""
    var unclickedSame = false
    var typeSelected = false
    var selectionType = 0
    var firstresponseType = false
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var guideBtn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    
    
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var criteria1: UIButton!
    @IBOutlet weak var criteria4: UIButton!
    @IBOutlet weak var criteria5: UIButton!
    @IBOutlet weak var criteria6: UIButton!
    @IBOutlet weak var criteria3: UIButton!
    @IBOutlet weak var criteria2: UIButton!
    
    
    var firstqStart = 0
    var response_type = [String]()
    var responsetypes = ["agreement", "change", "elaboration", "disagreement", "question", "teacher"]
    var prev_type_response = ""
        
    var prev_lineType = ""
    var moreSpeakTime:Bool = false
    var isRecording = false
    var recordingDate = ""
    var tableSetting:[Int] = []
    var keyNames:[String] = ["Seat1","Seat2","Seat3","Seat4","Seat5","Seat6","Seat7","Seat8","Seat9","Seat10", "Seat11","Seat12","Seat13","Seat14", "Seat15", "Seat16"]
    var names:[String?] = []
    var usedQuestions:[questionSet] = []
    var buttonEnabes:[Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false, false,false]
    var minute = 0 //initial time
    var second = 0
    var finishedTime = 0
    var initialTime = 0
    var time_fourth = 0
    var sameBtn = false
    
    var index = 0
    var duration = 0
    
    var btnQueue: [UIButton] = []
    
    var currentPoint = CGPoint()
    
    var firstBtn:Bool = true
    
    var firstPoint: CGPoint?
    var secondPoint: CGPoint?
    
    var prevBtn = UIButton()
    
    var SELECTEDBtn = UIButton()
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting: Bool = false
    
    var responseList = [String]()
    var responseBList = [String]()
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var questionView: UIView!
    
    static let topicNotification = Notification.Name("myNotification")
    static let addQuestionNotification = Notification.Name("addQuestionNotification")
    static let questionNotification = Notification.Name("my_Q_Notfication") //keep receiving
    @IBOutlet weak var startStopButton: UIButton!
    
    
    private var selectedIdx = 0
    private var selectedText = ""
    private var selectedLink = ""
    private var selectedQuestions = [String]()
    
    private var selectedTextLink = String()
    
    private var currentQuestion = String()
    private var discussionStarted = false
    private var receivedFirstQ = false
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
    
    @IBOutlet weak var Seat1: UIButton!
    @IBOutlet weak var Seat2: UIButton!
    @IBOutlet weak var Seat3: UIButton!
    @IBOutlet weak var Seat4: UIButton!
    @IBOutlet weak var Seat5: UIButton!
    @IBOutlet weak var Seat6: UIButton!
    @IBOutlet weak var Seat7: UIButton!
    @IBOutlet weak var Seat8: UIButton!
    @IBOutlet weak var Seat9: UIButton!
    @IBOutlet weak var Seat10: UIButton!
    @IBOutlet weak var Seat11: UIButton!
    @IBOutlet weak var Seat12: UIButton!
    @IBOutlet weak var Seat13: UIButton!
    @IBOutlet weak var Seat14: UIButton!
    @IBOutlet weak var Seat15: UIButton!
    @IBOutlet weak var Seat16: UIButton!
    
    @IBOutlet weak var table: UIImageView!
    
    private var questionStart = 0
    private var questionEnd = 0
    
    
    @IBOutlet weak var startButton: UIButton!
    
    var firstSpeaker: Bool = true
    var startTime: Int = 0
    var endTime: Int = 0
    var numParticipants = 0
    
    var tableConfig = [Int:UIImage]()
    var buttons = [UIButton]()
    var partNames = [UILabel]()
    var tableNames = [String]()
    
    var responseTypeCnt: [Int] = [0,0,0,0,0,0]
    var speakingTime:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var frequencySpeak:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    //recording ---
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName: String = ""
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(send_criterias)
        view.backgroundColor = .white
        
        let criterias:[UIButton] = [criteria1, criteria2, criteria3, criteria4, criteria5, criteria6]
        
        for i in 1...send_criterias[0].count {
            print(criterias[i-1])
            print(send_criterias[0][i-1])
            criterias[i-1].setTitle(send_criterias[0][i-1], for: .normal)
            criterias[i-1].isEnabled = true
        }
        
        startButton.layer.cornerRadius = 15
        
        questionView.layer.cornerRadius = 10
        questionView.layer.borderWidth = 2
        questionView.layer.borderColor = UIColor.gray.cgColor
        
        let date = Date()
        let dateString = CreateDiscussionViewController.dateFormatter.string(from: date)
//        print("discussion id: \(discussionId), code: \(selectedCode)")
        fileName = "\(discussionId)-Hark-\(dateString).m4a"
        setupRecorder()
        currentQuestionLabel.adjustsFontSizeToFitWidth = true
//        notification.isHidden = true
        stackView.isHidden = true
        questionView.isHidden = true
        minute = 0
        second = 0
        
        (startStopButton).addTarget(self,
                                    action: #selector(startStopClicked),
                                    for: .touchUpInside)
    
        recordButton.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: DiscussionViewController.topicNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRegisterNotification(notification:)), name: DiscussionViewController.addQuestionNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(on_Q_Notification(notification:)), name: DiscussionViewController.questionNotification, object: nil)
        
        self.partNames = [self.name1, self.name2, self.name3, self.name4, self.name5, self.name6, self.name7, self.name8, self.name9, self.name10, self.name11, self.name12, self.name13, self.name14, self.name15, self.name16]
        
        self.buttons = [self.Seat1, self.Seat2, self.Seat3, self.Seat4, self.Seat5, self.Seat6, self.Seat7, self.Seat8, self.Seat9, self.Seat10, self.Seat11, self.Seat12, self.Seat13, self.Seat14,self.Seat15, self.Seat16 ]
        
        
        for btn in self.buttons{
            btn.isEnabled = false
        }
        
        if modeSwitch == false {
            criteria1.isEnabled = false
            criteria2.isEnabled = false
            criteria3.isEnabled = false
            criteria4.isEnabled = false
            criteria5.isEnabled = false
            criteria6.isEnabled = false
            
            criteria1.isHidden = true
            criteria2.isHidden = true
            criteria3.isHidden = true
            criteria4.isHidden = true
            criteria5.isHidden = true
            criteria6.isHidden = true
        }
        else {
            criteria1.isEnabled = true
            criteria2.isEnabled = true
            criteria3.isEnabled = true
            criteria4.isEnabled = true
            criteria5.isEnabled = true
            criteria6.isEnabled = true
            
            criteria1.isHidden = false
            criteria2.isHidden = false
            criteria3.isHidden = false
            criteria4.isHidden = false
            criteria5.isHidden = false
            criteria6.isHidden = false
        }
        
        currentPoint = table.center
        setTable()
        
        criteria1.layer.cornerRadius = 15
        criteria1.layer.borderColor = CGColor(red: 124/255, green: 187/255, blue: 0, alpha: 1)
        criteria1.layer.borderWidth = 5
        
        criteria2.layer.cornerRadius = 15
        criteria2.layer.borderColor = CGColor(red: 246/255, green: 83/255, blue: 20/255, alpha: 1)
        criteria2.layer.borderWidth = 5
        
        criteria3.layer.cornerRadius = 15
        criteria3.layer.borderColor = CGColor(red: 255/255, green: 187/255, blue: 0, alpha: 1)
        criteria3.layer.borderWidth = 5
        
        criteria4.layer.cornerRadius = 15
        criteria4.layer.borderColor = CGColor(red: 0/255, green: 161/255, blue: 241/255, alpha: 1)
        criteria4.layer.borderWidth = 5
        
        criteria5.layer.cornerRadius = 15
        criteria5.layer.borderColor = CGColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1)
        criteria5.layer.borderWidth = 5
        
        criteria6.layer.cornerRadius = 15
        criteria6.layer.borderColor = CGColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1)
        criteria6.layer.borderWidth = 5
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //function displaying alerts
    func displayAlerts(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func startDiscussionTapped(_ sender: Any) {
        
        let vc = registerQuestionsViewController()
        vc.discussionId = discussionId
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    @IBAction func textButtonPushed(_ sender: Any) {
        openUrl(urlStr: selectedTextLink)
        self.startStopClicked()
    }
    
    func openUrl(urlStr: String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func onNotification(notification:Notification)
    {
        if let dict = notification.userInfo as NSDictionary? {
            if let slctIdx = dict["slctIdx"] as? Int,
               let slctTxt = dict["slctTxt"] as? String,
               let slctLink = dict["slctLink"] as? String,
               let slctQuestions = dict["slctQuestions"] as? [String] {
                self.selectedText = slctTxt
                self.selectedLink = slctLink
                self.selectedQuestions = slctQuestions
                self.selectedIdx = slctIdx
            }
        }
        textSelected = true
    }
    
    func setupRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        print(audioFilename)
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.2] as [String : Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting )
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    @IBAction func audioRecordButton(_ sender: Any) {
        if isRecording == false {
            isRecording = true
            soundRecorder.record()
            recordButton.isEnabled = false
        }
    }
    
    
    @objc func onRegisterNotification(notification:Notification)
    {
        //adding student-registered questions to the teacher's list of questions
        if let dict = notification.userInfo as NSDictionary? {
            if let regisQuestions = dict["questions"] as? [String] {
                self.selectedQuestions.append(contentsOf: regisQuestions)
                self.registeredQuestions = regisQuestions
                self.addRegistered()
            }
        }
    }
    
    @objc func on_Q_Notification(notification:Notification)
    {
        if let dict = notification.userInfo as NSDictionary? {
            print("called")
            if let question = dict["question"] as? String,
               let newQuestions = dict["new_questions"] as? [String],
               let verystartTime = dict["time"] as? Int
            {
                firstqStart = verystartTime * 60
                print(newQuestions)
                for i in newQuestions {
                    selectedQuestions.append(i)
                    registeredQuestions.append(i)
                }
//                if newQuestions.isEmpty != true{
//                    DatabaseManager.shared.addQuestions(discussionID: discussionId, newQs: newQuestions, completion: {success in
//                        if(success){
//                            print("questions recorded")
//                        }
//                        else{
//                            print("error recording")
//                        }
//                    })
//                }
                if (receivedFirstQ == true){
                    usedQuestions.append(questionSet(question: currentQuestion, duration: questionStart-count))
                }
                questionStart = count
                
                self.currentQuestion = question
                startStopClicked()
            }
        }
        
        if receivedFirstQ == false{
            questionStart = firstqStart
            receivedFirstQ = true
            startButton.isHidden = true
            stackView.isHidden = false
            questionView.isHidden = false
            startDiscussion()
        }
        
        currentQuestionLabel.text = self.currentQuestion
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if textSelected == false{
            topicPopOver()
        }
        else if initialQuestionPop == false{
            self.performSegue(withIdentifier: "questionVC2", sender: nil)
            initialQuestionPop = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "questionVC2"){
            if(receivedFirstQ == true){
                self.startStopClicked()
            }
            let displayVC = segue.destination as! QuestionPopViewController
            displayVC.selectedQuestions = self.selectedQuestions
            displayVC.firstq = self.receivedFirstQ
            
            var questionused:[String] = []
            for used in usedQuestions {
                questionused.append(used.question)
            }
            
            displayVC.usedquestions = questionused
            displayVC.callback = { time in
                guard let min = time else {return}
                var minTime = ""
                if (min>=0 && min<10){
                    minTime = "0" + String(min)
                }
                else {
                    minTime = String(min)
                }
                self.timeLabel.text = "\(minTime):00"
                self.count = min * 60
                self.initialTime = min * 60
                self.time_fourth = self.count/4
                self.startStopClicked()
            }
        }
        
        if(segue.identifier == "topicPopoverSeg"){
            let displayVC = segue.destination as! TopicPoppingViewController
            displayVC.setting = setting
            displayVC.texts = send_texts
            displayVC.criterias = send_criterias
            displayVC.questions = send_questions
            displayVC.textLinks = send_textLinks
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: DiscussionViewController.topicNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: DiscussionViewController.questionNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: DiscussionViewController.addQuestionNotification, object: nil)
    }
    
    //setting buttons with users
    func setTable(){
        tableConfig = [1: UIImage(named: "chair-green")!, 2: UIImage(named: "chair-green")!, 3: UIImage(named: "chair-green")!, 4: UIImage(named: "chair-green")!,5: UIImage(named: "chair-green")!,6: UIImage(named: "chair-green")!,7: UIImage(named: "chair-green")!,8: UIImage(named: "chair-green")!,9: UIImage(named: "chair-green")!,10: UIImage(named: "chair-green")!, 11: UIImage(named: "chair-green")!, 12: UIImage(named: "chair-green")!, 13: UIImage(named: "chair-green")!, 14: UIImage(named: "chair-green")!, 15: UIImage(named: "chair-green")!, 16: UIImage(named: "chair-green")!]
        var cnt = 0
        for i in tableSetting {
            tableConfig[i] = UIImage(named: "boy-icon")
            partNames[i-1].text = names[cnt]
            buttonEnabes[i-1] = true
            cnt+=1
        }
        for (element, image) in tableConfig {
            self.buttons[element-1].setImage(image, for: .normal)
            self.buttons[element-1].isEnabled = buttonEnabes[element-1]
            self.buttons[element-1].imageView?.contentMode = .scaleAspectFit
        }
        
        for name in partNames{
            tableNames.append(name.text!)
        }
        numParticipants = names.count
    }
    
    func topicPopOver(){
        self.performSegue(withIdentifier: "topicPopoverSeg", sender: nil)
    }
    
    
    func startDiscussion(){
        startStopClicked()
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        eraseShadow(button: prevBtn)
        var selectedBtn = UIButton()
        switch sender.tag{
        case 1:
            selectedBtn = Seat1
        case 2:
            selectedBtn = Seat2
        case 3:
            selectedBtn = Seat3
        case 4:
            selectedBtn = Seat4
        case 5:
            selectedBtn = Seat5
        case 6:
            selectedBtn = Seat6
        case 7:
            selectedBtn = Seat7
        case 8:
            selectedBtn = Seat8
        case 9:
            selectedBtn = Seat9
        case 10:
            selectedBtn = Seat10
        case 11:
            selectedBtn = Seat11
        case 12:
            selectedBtn = Seat12
        case 13:
            selectedBtn = Seat13
        case 14:
            selectedBtn = Seat14
        case 15:
            selectedBtn = Seat15
        case 16:
            selectedBtn = Seat16
        default:
            print("default btn")
            
        }
        
        setShadow(button: selectedBtn)
        buttonTapped(selectedBtn: selectedBtn)
        
    }
    
    @IBAction func responseTypePushed(_ sender: UIButton) {
        var selectedRespBtn = UIButton()
        var type = 0
        switch sender.tag{
        case 1:
            selectedRespBtn = criteria1
            type = 1
            responseTypeCnt[0] += 1
        case 2:
            selectedRespBtn = criteria2
            type = 2
            responseTypeCnt[1] += 1
        case 3:
            selectedRespBtn = criteria3
            type = 3
            responseTypeCnt[2] += 1
        case 4:
            selectedRespBtn = criteria4
            type = 4
            responseTypeCnt[3] += 1
        case 5:
            selectedRespBtn = criteria5
            type = 5
            responseTypeCnt[4] += 1
        case 6:
            selectedRespBtn = criteria6
            type = 6
            responseTypeCnt[5] += 1
        default:
            print("default btn")
            
        }
        selectedRespBtn.isEnabled = false
        response_type.append(send_criterias[0][sender.tag-1])
        
        //enable speaking buttons
        if(modeSwitch == true){
            typeSelected = true
//            notification.isHidden = true
            for (element, _) in tableConfig {
                self.buttons[element-1].isEnabled = buttonEnabes[element-1]
            }
            
            if (firstresponseType == false){
                addLine(toPoint: prevBtn.center, lineType: prev_type_response, type: type)
                firstresponseType = true
            }
        }
    }
    
    func setShadow(button: UIButton){
        button.backgroundColor = UIColor(red: 0.678, green: 0.847, blue: 0.902, alpha: 1.0)
    }
    
    func eraseShadow(button: UIButton){
        button.backgroundColor = .none
    }
    
    func buttonTapped(selectedBtn: UIButton){
        
        let touchPoint = selectedBtn.center
        secondPoint = touchPoint
        
        if firstBtn{
            btnQueue.append(selectedBtn)
            firstresponseType = false
            typeSelected = false
            firstBtn = false
            startTime = count
            currentPoint = selectedBtn.center
        }
        
        else if (prevBtn==selectedBtn){
            selectionType = 0
            if (selectedBtn.backgroundColor == .none){ // starting time record
                btnQueue.append(selectedBtn)
                firstresponseType = false
                typeSelected = false
                resetBtn()
                response_type = []
                responseList = []
                responseBList = []
                selectedBtn.backgroundColor = UIColor(red: 0.678, green: 0.847, blue: 0.902, alpha: 1.0)
                startTime = count
            }
            else {
                unclickedSame = true
                selectedBtn.backgroundColor = .none //ending the time record of the same person
                endTime = count
                let indexOfSelected = buttons.firstIndex(of: selectedBtn)
                duration = startTime - endTime
                speakingTime[indexOfSelected!] += duration
                frequencySpeak[indexOfSelected!] += 1
                
                guard let ids = indexOfSelected else {
                    return
                }
                index = ids
                presentoptions()
                
            }
        }
        else if !(prevBtn==selectedBtn){
            lineCnt += 1
            selectionType = 1
            if (sameBtn == true){
                btnQueue.append(selectedBtn)
                firstresponseType = false
                typeSelected = false
                resetBtn()
                response_type = []
                responseList = []
                responseBList = []
                
                startTime = count
                sameBtn = false
            }
            else if (sameBtn == false){
                btnQueue.append(selectedBtn)
                firstresponseType = false
                typeSelected = false
                endTime = count
                let indexOfSelected = buttons.firstIndex(of: prevBtn)
                duration = startTime - endTime
                speakingTime[indexOfSelected!] += duration
                frequencySpeak[indexOfSelected!] += 1
                
                guard let ids = indexOfSelected else {
                    return
                }
                index = ids
            }
            presentoptions()
        }
        
        if(modeSwitch == true){
            if(typeSelected == false){
//                notification.isHidden = false
                for (element, _) in tableConfig {
                    self.buttons[element-1].isEnabled = false
                }
            }
        }
        prevBtn = selectedBtn
        return
    }
    
    private func presentoptions(){
        self.addToFlow(person: partNames[index].text!, startTime: startTime, endTime: endTime, duration: duration, responseType:response_type, responseAList:responseList, responseBList:responseBList)
        
        if (modeSwitch == false){
            for (element, _) in tableConfig {
                self.buttons[element-1].isEnabled = buttonEnabes[element-1]
            }
            addLine(toPoint: prevBtn.center, lineType: nil, type: nil)
            
        }
        
        
        if(selectionType==0){
            sameBtn = true
        }
        else if(selectionType==1){
            resetBtn()
            response_type = []
            responseList = []
            responseBList = []
            startTime = endTime
        }
        
//        addLine(toPoint: prevBtn.center, lineType: prev_type_response)
        currentPoint = secondPoint!
        
        secondPoint = nil
    }
    
    func addLine(toPoint end:CGPoint, lineType:String?, type: Int?) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        if (btnQueue.count >= 2){
            linePath.move(to: btnQueue[0].center)
            linePath.addLine(to: btnQueue[1].center)
            btnQueue.removeFirst(1)
        }
        
        line.path = linePath.cgPath
        
        if modeSwitch == false{
            line.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3).cgColor
        }
        else if modeSwitch == true{
            if(type == 1){
                line.strokeColor = UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 0.3).cgColor
            }
            else if(type == 2){
                line.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3).cgColor
            }
            else if(type == 3){
                line.strokeColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.3).cgColor
            }
            else if(type == 4){
                line.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
            }
            else if(type == 5){
                line.strokeColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1).cgColor
            }
            else if(type == 6){
                line.strokeColor = UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 0.3).cgColor
            }
            else{
                line.strokeColor = UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor
            }
            prev_lineType = lineType!
        }
    

        line.lineWidth = 2
        line.lineJoin = CAShapeLayerLineJoin.round
        self.view.layer.addSublayer(line)
        
    }
    
    
    private func addToFlow(person:String,startTime: Int, endTime: Int, duration: Int, responseType:[String], responseAList:[String],responseBList:[String]){
        
        if (responseType.isEmpty != true){
            DatabaseManager.shared.recordDiscussionFlow(with: discussionId, selectedPerson: person, startTime: startTime, endTime: endTime, duration: duration, responseType: responseType, responseAList: responseAList, responseBList: responseBList, completion: {success in
                if(success){
                    print("recorded")
                }
                else{
                    print("error recording")
                }
            })
        }
    }
    
  
    @IBAction func stopClicked(_ sender: Any) {
        timer.invalidate()
        discussionEnded()
    }
    
    
    @objc func startStopClicked() {
        if(timerCounting){
            timerCounting = false
            timer.invalidate()
            startStopButton.setBackgroundImage(UIImage(named: "start-1"), for: .normal)
            for button in buttons{
                button.isEnabled = false
            }
        }
        else{
            timerCounting = true
            startStopButton.setBackgroundImage(UIImage(named: "resume-1"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            for (element, _) in tableConfig {
                self.buttons[element-1].isEnabled = buttonEnabes[element-1]
            }
        }
    }
    
    func addRegistered(){
        spinner.show(in: view)
        print(registeredQuestions)
        DatabaseManager.shared.finishCreatingDiscussion(discussionID: discussionId, registeredQs: registeredQuestions, completion: {success in
                    if(success){
                        DispatchQueue.main.async {
                            self.spinner.dismiss()
                        }
                    }
                    else{
                        print("error in adding the discussion")
                        DispatchQueue.main.async {
                            self.spinner.dismiss()
                        }
                    }
                })
    }
    
    @objc func timerCounter() -> Void {
        
        if(count==time_fourth && numParticipants >= 5){
            //delegate time to those who spoke the least
            speakMoreTime()
            startStopClicked()
        }
        if(count == 1){
            timer.invalidate()
            discussionEnded()
        }
        count = count - 1
        let time = timerFormat(seconds: count)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        timeLabel.text = timeString
    }
    
    func timerFormat(seconds: Int) -> (Int, Int){
        return ((seconds/60),(seconds % 60)) //min , seconds
    }
    
    func makeTimeString(minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }

    
    func discussionEnded(){
        usedQuestions.append(questionSet(question: currentQuestion, duration: questionStart-count))
        
        finishedTime = count
        
        print("result---")
        print("names---")
        print(tableNames)
        print("speakingTime---")
        print(speakingTime)
        print("frequencySpeak---")
        print(frequencySpeak)
        
        let resultVC = ResultViewController()
        
        resultVC.modeSwitch = modeSwitch
        resultVC.tableName = self.tableNames
        resultVC.speakFrequency = self.frequencySpeak
        resultVC.discussionId = self.discussionId
        resultVC.speakTime = self.speakingTime
        resultVC.questions = self.usedQuestions
        resultVC.initialTime = self.initialTime
        resultVC.finishTime = self.finishedTime
        resultVC.responseTypeCnt = self.responseTypeCnt
        resultVC.numParticipants = self.numParticipants
        resultVC.lineCnt = self.lineCnt
        resultVC.send_criterias = self.send_criterias[0]
        
        if isRecording {
            soundRecorder.stop()
            soundRecorder = nil
            resultVC.filename = self.fileName
        }
        
        DatabaseManager.shared.recordDiscussionResult(with: discussionId, speakFrequency: frequencySpeak, speakTime: speakingTime, usedQuestions: usedQuestions, initialTime: initialTime, finishTime: finishedTime, responseTypeCnt: responseTypeCnt, lineCnt: lineCnt, names: tableNames, classroomCode: classroomCode, completion: {success in
            if(success){
//                print("success")
            }
            else{
                print("error in saving the result")
            }
        })
        
        
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
    func speakMoreTime(){
//        print("time for some to speak more")
        var peopleAllowed = [Int]()
        var peopleNotAllowed = [Int]()
        var totalTime = 0
        for t in speakingTime{
            totalTime += t
        }
        
        let averageSpoken = totalTime/numParticipants
        var cnt = 0
        for value in speakingTime{
            if (value < averageSpoken) {
                peopleAllowed.append(cnt)
            }
            else{
                peopleNotAllowed.append(cnt)
            }
            cnt += 1
        }
        let y = numParticipants - peopleNotAllowed.count
        if !(y < 3) {
            showAlert()
            for i in peopleNotAllowed {
                if (buttons[i].isEnabled==true){
                    buttons[i].isEnabled = false
                }
            }
        }
    }
    
    func resetBtn(){
        let criterias:[UIButton] = [criteria1, criteria2, criteria3, criteria4, criteria5, criteria6]
        for i in 1...send_criterias[0].count {
            criterias[i-1].isEnabled = true
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Speak Up Time", message: "participants who spoke less than the table average will be given time to speak up from now to the end of the discussion!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: {action in
            self.count = self.count - 1
            self.startStopClicked()
        }))
        present(alert, animated: true)
    }
}
