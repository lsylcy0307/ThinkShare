//
//  DiscussionViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/07/31.
//

import UIKit
import AVFoundation

class DiscussionViewController: UIViewController, AVAudioRecorderDelegate {
    
    public var setting:registeredSetting?
    
    public var discussionId = ""
    public var selectedCode = ""
    private var textSelected = false
    private var initialQuestionPop = false
    private var registeredQuestions = [String]()
    
    var selectionType = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //buttons
    @IBOutlet weak var guideBtn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    
    //----
    @IBOutlet weak var currentQuestionLabel: UILabel!
    
    var type_response = ""
    var prev_type_response = ""
        
    var prev_lineType = ""
    var moreSpeakTime:Bool = false
    var isRecording = false
    var recordingDate = ""
    var tableSetting:[Int] = []
    var keyNames:[String] = ["Seat1","Seat2","Seat3","Seat4","Seat5","Seat6","Seat7","Seat8","Seat9","Seat10"]
    var names:[String?] = []
    var usedQuestions:[String] = []
    var buttonEnabes:[Bool] = [false,false,false,false,false,false,false,false,false,false]
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
    @IBOutlet weak var table: UIImageView!
    
    @IBOutlet weak var react1a: UIButton!
    @IBOutlet weak var react1b: UIButton!
    @IBOutlet weak var react2a: UIButton!
    @IBOutlet weak var react2b: UIButton!
    @IBOutlet weak var react3a: UIButton!
    @IBOutlet weak var react3b: UIButton!
    @IBOutlet weak var react4a: UIButton!
    @IBOutlet weak var react4b: UIButton!
    @IBOutlet weak var react5a: UIButton!
    @IBOutlet weak var react5b: UIButton!
    @IBOutlet weak var react6a: UIButton!
    @IBOutlet weak var react6b: UIButton!
    @IBOutlet weak var react7a: UIButton!
    @IBOutlet weak var react7b: UIButton!
    @IBOutlet weak var react8a: UIButton!
    @IBOutlet weak var react8b: UIButton!
    @IBOutlet weak var react9a: UIButton!
    @IBOutlet weak var react9b: UIButton!
    @IBOutlet weak var react10a: UIButton!
    @IBOutlet weak var react10b: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    var firstSpeaker: Bool = true
    var startTime: Int = 0
    var endTime: Int = 0
    var numParticipants = 0
    
    var tableConfig = [Int:UIImage]()
    var buttons = [UIButton]()
    var reactAButtons = [UIButton]()
    var reactBButtons = [UIButton]()
    var partNames = [UILabel]()
    var tableNames = [String]()
    
    var speakingTime:[Int] = [0,0,0,0,0,0,0,0,0,0,0]
    var frequencySpeak:[Int] = [0,0,0,0,0,0,0,0,0,0,0]
    
    //recording ---
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    lazy var popUpWindow: PopUp = {
        let view = PopUp()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName: String = ""
    
    //start disucssion -> register question -> set timer/choose questions
    
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let date = Date()
        let dateString = CreateDiscussionViewController.dateFormatter.string(from: date)
//        print("discussion id: \(discussionId), code: \(selectedCode)")
        fileName = "\(discussionId)-Hark-\(dateString).m4a"
        setupRecorder()
        currentQuestionLabel.adjustsFontSizeToFitWidth = true
        
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
        
        self.partNames = [self.name1, self.name2, self.name3, self.name4, self.name5, self.name6, self.name7, self.name8, self.name9, self.name10]
        
        self.buttons = [self.Seat1, self.Seat2, self.Seat3, self.Seat4, self.Seat5, self.Seat6, self.Seat7, self.Seat8, self.Seat9, self.Seat10]
        
        self.reactAButtons = [react1a,react2a,react3a,react4a,react5a,react6a,react7a,react8a,react9a,react10a]
        
        self.reactBButtons = [react1b,react2b,react3b,react4b,react5b,react6b,react7b,react8b,react9b,react10b]
        
        for btn in self.buttons{
            btn.isEnabled = false
        }
        for btn in self.reactAButtons{
            btn.isEnabled = false
        }
        for btn in self.reactBButtons{
            btn.isEnabled = false
        }
        
        currentPoint = table.center
        setTable()
        
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
            }
        }
    }
    
    @objc func on_Q_Notification(notification:Notification)
    {
        if receivedFirstQ == false{
            receivedFirstQ = true
            startButton.isHidden = true
            stackView.isHidden = false
            questionView.isHidden = false
            startDiscussion()
        }
        
        if let dict = notification.userInfo as NSDictionary? {
            if let question = dict["question"] as? String{
                usedQuestions.append(question)
                self.currentQuestion = question
                startStopClicked()
            }
        }
        currentQuestionLabel.text = self.currentQuestion
        print("notification_question: \(self.currentQuestion)")
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
            displayVC.usedquestions = self.usedQuestions
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
                print("intial setting: \(minTime):\(self.second)")
                self.count = min * 60
                self.initialTime = min * 60
                self.time_fourth = self.count/4
                self.startStopClicked()
            }
        }
        
        if(segue.identifier == "topicPopoverSeg"){
            let displayVC = segue.destination as! TopicPoppingViewController
            
            displayVC.setting = setting
        }
        
    }
    
    deinit {
        print("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self, name: DiscussionViewController.topicNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: DiscussionViewController.questionNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: DiscussionViewController.addQuestionNotification, object: nil)
    }
    
    //setting buttons with users
    func setTable(){
        tableConfig = [1: UIImage(named: "chair1")!, 2: UIImage(named: "chair1")!, 3: UIImage(named: "chair1")!, 4: UIImage(named: "chair2")!,5: UIImage(named: "chair2")!,6: UIImage(named: "chair4")!,7: UIImage(named: "chair4")!,8: UIImage(named: "chair4")!,9: UIImage(named: "chair3")!,10: UIImage(named: "chair3")!]
        var cnt = 0
        for i in tableSetting {
            print("selected tables: \(i)")
            tableConfig[i] = UIImage(named: "Boy")
            partNames[i-1].text = names[cnt]
            buttonEnabes[i-1] = true
            cnt+=1
        }
        for (element, image) in tableConfig {
            self.buttons[element-1].setImage(image, for: .normal)
            self.buttons[element-1].isEnabled = buttonEnabes[element-1]
            self.buttons[element-1].imageView?.contentMode = .scaleAspectFit
            self.reactAButtons[element-1].isHidden = !buttonEnabes[element-1]
            self.reactBButtons[element-1].isHidden = !buttonEnabes[element-1]
            self.reactAButtons[element-1].isEnabled = buttonEnabes[element-1]
            self.reactBButtons[element-1].isEnabled = buttonEnabes[element-1]
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
        default:
            print("default btn")
            
        }
        
        setShadow(button: selectedBtn)
        buttonTapped(selectedBtn: selectedBtn)
        
    }
    
    @IBAction func responseAbtnClick(_ sender: UIButton) {
        var selectedRespABtn = UIButton()
        switch sender.tag{
        case 1:
            selectedRespABtn = react1a
        case 2:
            selectedRespABtn = react2a
        case 3:
            selectedRespABtn = react3a
        case 4:
            selectedRespABtn = react4a
        case 5:
            selectedRespABtn = react5a
        case 6:
            selectedRespABtn = react6a
        case 7:
            selectedRespABtn = react7a
        case 8:
            selectedRespABtn = react8a
        case 9:
            selectedRespABtn = react9a
        case 10:
            selectedRespABtn = react10a
        default:
            print("default btn")
            
        }
        selectedRespABtn.isEnabled = false
        responseList.append(partNames[sender.tag-1].text!)
    }
    
    @IBAction func responseBbtnClick(_ sender: UIButton) {
        var selectedRespBBtn = UIButton()
        switch sender.tag{
        case 1:
            selectedRespBBtn = react1b
        case 2:
            selectedRespBBtn = react2b
        case 3:
            selectedRespBBtn = react3b
        case 4:
            selectedRespBBtn = react4b
        case 5:
            selectedRespBBtn = react5b
        case 6:
            selectedRespBBtn = react6b
        case 7:
            selectedRespBBtn = react7b
        case 8:
            selectedRespBBtn = react8b
        case 9:
            selectedRespBBtn = react9b
        case 10:
            selectedRespBBtn = react10b
        default:
            print("default btn")
            
        }
        
        selectedRespBBtn.isEnabled = false
        responseBList.append(partNames[sender.tag-1].text!)
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
            firstBtn = false
            btnQueue.append(selectedBtn) // b , c, d // a , a, c // a, a, a, s
            startTime = count
            currentPoint = selectedBtn.center
        }
        
        else if (prevBtn==selectedBtn){
            if (selectedBtn.backgroundColor == .none){ // starting time record
                print("same button clicked: talking")
                btnQueue.append(selectedBtn)
                //presentOptions()
                resetBtn()
                responseList = []
                responseBList = []
                selectedBtn.backgroundColor = UIColor(red: 0.678, green: 0.847, blue: 0.902, alpha: 1.0)
                startTime = count
            }
            else {
                selectedBtn.backgroundColor = .none
                endTime = count
                let indexOfSelected = buttons.firstIndex(of: selectedBtn)
                duration = startTime - endTime
                speakingTime[indexOfSelected!] += duration
                frequencySpeak[indexOfSelected!] += 1
                
                guard let ids = indexOfSelected else {
                    return
                }
                index = ids
                
                presentOptions(type: 0)
                //add flow to db
                
            }
        }
        else if !(prevBtn==selectedBtn){
            btnQueue.append(selectedBtn)
            if (sameBtn == true){
                print("previously deselected the same btn")
                btnQueue.append(selectedBtn)
                //presentOptions()
                resetBtn()
                responseList = []
                responseBList = []
                startTime = count
                sameBtn = false
            }
            else if (sameBtn == false){
                print("moving to next btn")
                endTime = count
                let indexOfSelected = buttons.firstIndex(of: prevBtn)
                duration = startTime - endTime
                speakingTime[indexOfSelected!] += duration
                frequencySpeak[indexOfSelected!] += 1
                
                guard let ids = indexOfSelected else {
                    return
                }
                index = ids
                
                presentOptions(type: 1)
            }
        }
        prevBtn = selectedBtn
        
        return
    }
    
    private func presentOptions(type: Int){
        view.addSubview(popUpWindow)
        selectionType = type
        popUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpWindow.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        popUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5){
            self.visualEffectView.alpha = 1
            self.popUpWindow.alpha = 1
            self.popUpWindow.transform = CGAffineTransform.identity
        }
    }
    
    private func addToFlow(person:String,startTime: Int, endTime: Int, duration: Int, responseType:String, responseAList:[String],responseBList:[String]){
        
        print("\(person), \(startTime), \(endTime), \(duration), \(responseType)")
        DatabaseManager.shared.recordDiscussionFlow(with: discussionId, selectedPerson: person, startTime: startTime, endTime: endTime, duration: duration, responseType: responseType, responseAList: responseAList, responseBList: responseBList, completion: {success in
            if(success){
                print("recorded")
            }
            else{
                print("error")
            }
        })
    }
    
  
    @IBAction func stopClicked(_ sender: Any) {
        timer.invalidate()
        discussionEnded()
    }
    
    
    @objc func startStopClicked() {
        if(timerCounting){
            timerCounting = false
            timer.invalidate()
            startStopButton.setBackgroundImage(UIImage(named: "resume"), for: .normal)
            for button in buttons{
                button.isEnabled = false
            }
        }
        else{
            timerCounting = true
            startStopButton.setBackgroundImage(UIImage(named: "pauseBtn"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            for (element, _) in tableConfig {
                self.buttons[element-1].isEnabled = buttonEnabes[element-1]
            }
        }
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
    
    func addLine(toPoint end:CGPoint, lineType:String) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        if (btnQueue.count >= 3){
            linePath.move(to: btnQueue[1].center)
            linePath.addLine(to: btnQueue[0].center)
            btnQueue.remove(at: 0)
            print(btnQueue)
        }
        line.path = linePath.cgPath
        
        
        if lineType == "" { line.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0).cgColor }
        else if lineType == "agreement" { line.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3).cgColor}
        else if lineType == "disagreement" { line.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor}
        else if lineType == "elaboration" { line.strokeColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.3).cgColor}
        else if lineType == "change" { line.strokeColor = UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 0.3).cgColor}
        
        prev_lineType = lineType
        
        line.lineWidth = 2
        line.lineJoin = CAShapeLayerLineJoin.round
        self.view.layer.addSublayer(line)
        
    }
    
    func discussionEnded(){
        print("Timer ended")
        finishedTime = count
        print("finished at: \(finishedTime)")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyBoard.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        resultVC.tableName = self.tableNames
        resultVC.speakFrequency = self.frequencySpeak
        resultVC.discussionId = self.discussionId
        resultVC.speakTime = self.speakingTime
        resultVC.questions = self.usedQuestions
        resultVC.initialTime = self.initialTime
        resultVC.finishTime = self.finishedTime
        
        if isRecording {
            soundRecorder.stop()
            soundRecorder = nil
            resultVC.filename = self.fileName
        }
        
        DatabaseManager.shared.recordDiscussionResult(with: discussionId, speakFrequency: frequencySpeak, speakTime: speakingTime, usedQuestions: usedQuestions, initialTime: initialTime, finishTime: finishedTime, completion: {success in
            if(success){
                print("success")
            }
            else{
                print("error in saving the result")
            }
        })
        
        
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
    func speakMoreTime(){
        print("time for some to speak more")
        var peopleAllowed = [Int]()
        var peopleNotAllowed = [Int]()
        var totalTime = 0
        for t in speakingTime{
            totalTime += t
        }
        
        let averageSpoken = totalTime/numParticipants
        print("average spoken: \(averageSpoken)")
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
        for (element, _) in tableConfig {
            self.reactAButtons[element-1].isEnabled = buttonEnabes[element-1]
            self.reactBButtons[element-1].isEnabled = buttonEnabes[element-1]
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Speak Up Time", message: "participants who spoke less than the table average will be given time to speak up from now to the end of the discussion!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: {action in
            print("tapped okay")
            self.count = self.count - 1
            self.startStopClicked()
        }))
        present(alert, animated: true)
    }
}


extension DiscussionViewController: PopUpDelegate{
    
    func onResponseReady(responseType: Int) {
        print("response type is: \(responseType)")
        
        
        if responseType == 1 { type_response = "agreement"}
        else if responseType == 2 { type_response = "disagreement"}
        else if responseType == 3 { type_response = "elaboration"}
        else if responseType == 4 { type_response = "change"}
        
        prev_type_response = type_response
        
        self.addToFlow(person: partNames[index].text!, startTime: startTime, endTime: endTime, duration: duration, responseType: prev_type_response,responseAList:responseList,responseBList:responseBList)
        
        if(selectionType==0){
            sameBtn = true
        }
        else if(selectionType==1){
            
            resetBtn()
            responseList = []
            responseBList = []
            startTime = endTime
        }
        
        addLine(toPoint: prevBtn.center, lineType: prev_type_response)
        currentPoint = secondPoint!
        
        secondPoint = nil
        
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }){ (_) in
            self.popUpWindow.removeFromSuperview()
            print("did remove popup")
        }
    }
}
