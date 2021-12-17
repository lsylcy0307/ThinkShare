
import Charts
import UIKit
import AVFoundation

struct flow {
    let name: String
    let duration: String
    let endTime: String
    let responseType: [String]
    let startTime: String
}

class ResultViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    var soundPlayer : AVAudioPlayer!
    var discussionFlows = [flow]()
    
    var pieChart = PieChartView()
    var barChart = BarChartView()
    var recordingPresent = true
//    var redView = UIView()
//    var blueView = UIView()
    var greenView = UIView()
    var purpleView = UIView()
    var pinkView = UIView()
    var tablesTitleView = UIView()
    var orangeView = UIView()
    var durationView = UIView()
    var participantsView = UIView()
    var linesView = UIView()
    var initialTime = 0
    var finishTime = 0
    var recordingPath: URL?
    var tableName = [String]()
    var speakTime = [Int]()
    var speakFrequency = [Int]()
    var responseTypeCnt = [Int]()
    var discussionId = ""
    var questions = [questionSet]()
    var nonZeroTableName = [String]()
    var nonZeroSpeakTime = [Int]()
    var filename = ""
    let responseTypes = ["agreement", "change", "expand", "disagreement"]
    
    let tableView = UITableView()
    let questionTableView = UITableView()
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Home", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "audio"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAudio), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discussion overview"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 41)
        label.textColor = .black
        return label
    }()
    
    lazy var tableTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Speaking distributions"
        label.font = UIFont(name: "NotoSansKannada-regular", size: 28)
        label.textColor = .black
        return label
    }()
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discussed Questions"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 16)
        label.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        return label
    }()
    
    lazy var questionTotalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "total"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 13)
        label.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.7)
        return label
    }()
    
    lazy var spokenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Response Types"
        label.font = UIFont(name: "HiraginoSans-W7", size: 15)
        label.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration> "
        label.font = UIFont(name: "HiraginoSans-W3", size: 35)
        label.textColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 1)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Discussion Analytics"
        print("filename: \(filename)")
        let duration = initialTime - finishTime
        let time = timerFormat(seconds: duration)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        durationLabel.text = "Duration: \(timeString)"
    
        barChart.delegate = self
        pieChart.delegate = self
        
        durationView.backgroundColor = .systemPink
        participantsView.backgroundColor = .purple
        linesView.backgroundColor = .yellow
//        orangeView.backgroundColor = .orange
//        greenView.backgroundColor = .green
        
        view.addSubview(scrollView)
        
        [pinkView, durationView, participantsView, linesView, orangeView, greenView, pieChart, barChart, tablesTitleView].forEach{ scrollView.addSubview($0) }
         
//       durationView , linesView, participantsView, pinkView, orangeView
//         , backButton, audioButton, pieChart, barChart, greenView, purpleView, ]
        
        
        pinkView.anchor(top: scrollView.safeAreaLayoutGuide.topAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 30, bottom: 0, right: 0), size: .init(width: 100, height:60))
        
        tablesTitleView.anchor(top: nil, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: pieChart.topAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 10, right: 0), size: .init(width: 100, height:40))
        
        durationView.anchor(top: pinkView.bottomAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 30, bottom: 0, right: 0), size: .init(width: 140, height:100))
        
        participantsView.anchor(top: pinkView.bottomAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 190, bottom: 0, right: 0), size: .init(width: 140, height:100))
        
        linesView.anchor(top: pinkView.bottomAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 350, bottom: 0, right: 0), size: .init(width: 140, height:100))
        
        //selected questions
        orangeView.anchor(top: pinkView.bottomAnchor, leading: nil, bottom: nil, trailing: scrollView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 100),size: .init(width: 320, height:250))

        //responnse type
        greenView.anchor(top: orangeView.bottomAnchor, leading: nil, bottom: nil, trailing: scrollView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 100), size: .init(width: 320, height: 350))
        
//        purpleView.anchor(top: pinkView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0), size: .init(width: 50, height: 40))
//
        //create a view and add in there
        pieChart.anchor(top: nil, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: greenView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0), size: .init(width: 300, height: 0))
        pieChart.heightAnchor.constraint(equalTo: pieChart.widthAnchor).isActive = true
        
        pieChart.layer.cornerRadius = 20
        pieChart.layer.borderColor = .init(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.3)
        pieChart.layer.borderWidth = 2
        barChart.layer.cornerRadius = 20
        barChart.layer.borderColor = .init(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.3)
        barChart.layer.borderWidth = 2
//
        barChart.anchor(top: nil, leading: pieChart.trailingAnchor, bottom: greenView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        barChart.heightAnchor.constraint(equalTo: pieChart.widthAnchor).isActive = true
        barChart.widthAnchor.constraint(equalTo: barChart.heightAnchor).isActive = true
//
        

//
//
//        greenView.addSubview(tableView)
        greenView.addSubview(spokenLabel)
        pinkView.addSubview(titleLabel)
        tablesTitleView.addSubview(tableTitleLabel)
//        purpleView.addSubview(durationLabel)
        orangeView.addSubview(questionTableView)
        orangeView.addSubview(questionLabel)
//        orangeView.addSubview(questionTotalLabel)
        
        scrollView.isUserInteractionEnabled = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        questionTableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.identifier)
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        
        scrollView.frame = view.bounds
        
        spokenLabel.frame = CGRect(x: 0, y: 0, width: greenView.width, height:20)
        tableView.frame =  CGRect(x: 0,
                                  y: spokenLabel.bottom+2,
                                  width: greenView.width,
                                  height: greenView.height-30)
        
        questionLabel.frame = CGRect(x: 0, y: 0, width: orangeView.width - 70, height: 20)
        //why not stick to the right edge?
//        questionTotalLabel.frame = CGRect(x: 150, y: 0, width: 60, height: 20)
        questionTableView.frame =  CGRect(x: 0,
                                          y: questionLabel.bottom+2,
                                          width: orangeView.width,
                                          height: orangeView.height-22)
        
        backButton.frame = CGRect(x:scrollView.width-210,
                                  y: pinkView.frame.midY,
                                   width: 200,
                                   height: 42)
        audioButton.frame = CGRect(x:scrollView.width - 300,
                                   y: pinkView.frame.midY,
                                   width: 64,
                                   height: 64)
        
        if filename == ""{
            print("is empty")
            recordingPresent = false
            audioButton.isEnabled = false
        }
        else{
            let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
            let manager = FileManager.default
            guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
                return
            }
            let newFolderURL = url.appendingPathComponent("ThinkShare-app")
            do {
                let fileURL = newFolderURL.appendingPathComponent(filename)
                print("creating file: \(fileURL.path)")
                let fileData = try Data(contentsOf: audioFilename)
                manager.createFile(atPath: fileURL.path, contents: fileData, attributes: [FileAttributeKey.creationDate:Date()])
            }
            catch{
                print(error)
            }
            setupPlayer()
        }
        
        var pieEntries = [PieChartDataEntry]()
        var barEntries = [BarChartDataEntry]()
        
        var cnt = 0
        for value in speakTime{
            if (value != 0) {
                let pieEntry = PieChartDataEntry()
                pieEntry.y = Double(value)
                pieEntry.label = tableName[cnt]
                pieEntries.append(pieEntry)
                nonZeroTableName.append(tableName[cnt])
                nonZeroSpeakTime.append(value)
            }
            cnt+=1
        }
        cnt = 0
        for freq in speakFrequency{
            if (freq != 0) {
                barEntries.append(BarChartDataEntry(x: Double(cnt+1), y: Double(freq), data: tableName[cnt]))
            }
            cnt+=1
        }
        
        tableView.reloadData()
        questionTableView.reloadData()

        // 3. chart setup
        let pieSet = PieChartDataSet( entries: pieEntries, label: "Speak Time Distribution")
        pieSet.colors = ChartColorTemplates.colorful()
        pieSet.selectionShift = 0
        let pieData = PieChartData(dataSet: pieSet)
        pieChart.data = pieData
        
        let barSet = BarChartDataSet( entries: barEntries, label: "Speaking Frequency Distribution")
        barSet.colors = ChartColorTemplates.joyful()
        let barData = BarChartData(dataSet: barSet)
        barChart.data = barData
        
        pieChart.noDataText = "No data available"
        pieChart.isUserInteractionEnabled = true
        pieChart.setExtraOffsets(left: 0 , top: 0, right: 0, bottom: 0)
        
        barChart.noDataText = "No data available"
        barChart.setExtraOffsets(left: 0 , top: 0, right: 0, bottom: 0)
    }
    
    
    func setupPlayer() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print(error)
        }
    }
    
    private func getDiscussionFlow(){
        DatabaseManager.shared.getDiscussionFlow(with: discussionId, completion: { [weak self]result in
            switch result {
            case .success(let flows):
                self?.discussionFlows = flows
                //end loading
            case .failure(let error):
                print("failed to get flows: \(error)")
            }
        })
        
        interpretFlow()
    }
    
    func interpretFlow(){
        //first load the discussion set up information
//        var speakingTime = [Int]()
//        var speakingFrequency = [Int]()
//        var responseTypesCnt = [Int]()
        
            //speaking time - pie chart
            
            
            //speaking frequency - bar graph
            //answered questions - table view
            //response types - table view
            //interactions - table view (in order of size)
            
            
            
            //organize the flow so that it is possible to compare the frequency
//        for i in 0...discussionFlows.count-1 {
//
//        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioButton.isEnabled = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView
        {
            return responseTypeCnt.count
        } else {
            questionTotalLabel.text = "\(questions.count) total"
            
            return questions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            cell.textLabel?.text = "\(responseTypes[indexPath.row]): \(responseTypeCnt[indexPath.row])"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as! QuestionTableViewCell
            cell.configure(with: .red, question: questions[indexPath.row].question, time: questions[indexPath.row].duration)
            return cell
        }
    }//100*150
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView
        {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    @objc private func didTapBack() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAudio(){
        if(audioButton.isEnabled == true){
            audioButton.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        }
        else{
            soundPlayer.stop()
            audioButton.isEnabled = true
        }
    }
}

extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


