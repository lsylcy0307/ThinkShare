
import Charts
import UIKit
import AVFoundation

class ResultViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    var soundPlayer : AVAudioPlayer!
    
    var pieChart = PieChartView()
    var barChart = BarChartView()
    var recordingPresent = true
//    var redView = UIView()
//    var blueView = UIView()
    var greenView = UIView()
    var purpleView = UIView()
    var pinkView = UIView()
    var orangeView = UIView()
    var initialTime = 0
    var finishTime = 0
    var recordingPath: URL?
    var tableName = [String]()
    var speakTime = [Int]()
    var speakFrequency = [Int]()
    var discussionId = ""
    var questions = [String]()
    var nonZeroTableName = [String]()
    var nonZeroSpeakTime = [Int]()
    var filename = ""
    
    let tableView = UITableView()
    let questionTableView = UITableView()
    
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("End Harkness", for: .normal)
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
        label.text = "Discussion Analytics "
        label.font = UIFont(name: "HiraginoSans-W7", size: 40)
        label.textColor = UIColor(red: 102/255, green: 0, blue: 102/255, alpha: 1)
        return label
    }()
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Questions Selected:"
        label.font = UIFont(name: "HiraginoSans-W7", size: 20)
        label.textColor = UIColor(red: 102/255, green: 0, blue: 102/255, alpha: 1)
        return label
    }()
    
    lazy var spokenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time Spoken:"
        label.font = UIFont(name: "HiraginoSans-W7", size: 20)
        label.textColor = UIColor(red: 102/255, green: 0, blue: 102/255, alpha: 1)
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
        
        [pieChart, barChart, greenView, purpleView, pinkView, orangeView, backButton, audioButton].forEach{ view.addSubview($0) }
        
        
        pinkView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 100, height:50))
        
        purpleView.anchor(top: pinkView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0), size: .init(width: 50, height: 40))
        
        pieChart.anchor(top: purpleView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0), size: .init(width: view.width/3, height: 0))
        pieChart.heightAnchor.constraint(equalTo: pieChart.widthAnchor).isActive = true
        
        barChart.anchor(top: purpleView.bottomAnchor, leading: pieChart.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        barChart.heightAnchor.constraint(equalTo: pieChart.widthAnchor).isActive = true
        barChart.widthAnchor.constraint(equalTo: barChart.heightAnchor).isActive = true
        
        greenView.anchor(top: purpleView.bottomAnchor, leading: barChart.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 0), size: .init(width: view.width/3, height: view.height*(2/3)))
        
        orangeView.anchor(top: pieChart.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: barChart.trailingAnchor, padding: .init(top: 20, left: 10, bottom: 0, right: 0))

        greenView.addSubview(tableView)
        greenView.addSubview(spokenLabel)
        pinkView.addSubview(titleLabel)
        purpleView.addSubview(durationLabel)
        orangeView.addSubview(questionTableView)
        orangeView.addSubview(questionLabel)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        questionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        spokenLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        tableView.frame =  CGRect(x: 0,
                                  y: spokenLabel.bottom+2,
                                  width: greenView.width,
                                  height: greenView.height-30)
        
        questionLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        questionTableView.frame =  CGRect(x: 0,
                                          y: questionLabel.bottom+2,
                                          width: orangeView.width,
                                          height: orangeView.height-30)
        
        backButton.frame = CGRect(x:view.width-210,
                                  y: pinkView.frame.midY,
                                   width: 200,
                                   height: 42)
        audioButton.frame = CGRect(x:view.width - 300,
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
                print(nonZeroTableName)
                print(nonZeroSpeakTime)
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
            return nonZeroSpeakTime.count/2
        } else {
            return questions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            let time = timerFormat(seconds: Int(nonZeroSpeakTime[indexPath.row]))
            let timeString = makeTimeString(minutes: time.0, seconds: time.1)
            cell.textLabel?.text = "Name: \(nonZeroTableName[indexPath.row]) |  Speak Time: \(timeString)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            cell.textLabel?.text = "\(questions[indexPath.row])"
            return cell
        }
    }//100*150
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView
        {
            print("\(nonZeroTableName[indexPath.row]) selected")
            tableView.deselectRow(at: indexPath, animated: false)
        }
        else {
            print("\(questions[indexPath.row]) selected")
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


