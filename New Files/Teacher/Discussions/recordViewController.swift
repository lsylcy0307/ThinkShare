//
//  recordViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/03/19.
//

import UIKit
import Charts
import DropDown

class recordViewController: UIViewController, ChartViewDelegate,UITableViewDelegate, UITableViewDataSource {
    
    
    var lineEntries_time = [ChartDataEntry]()
    var lineEntries_freq = [ChartDataEntry]()
    var lineEntries_time_av = [ChartDataEntry]()
    var lineEntries_freq_av = [ChartDataEntry]()
    
    
//    public var sort = ""
    public var modeSwitch = false
    var discussionFlows = [flow]()
    public var lineCnt = 0
    public var send_criterias = [String]()
    
    var lineChart_time = LineChartView()
    var lineChart_freq = LineChartView()
    
    
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
    
    var name = ""
    var speakTime = [Int]()
    var speakFrequency = [Int]()
    var speakTime_av = [Double]()
    var speakFrequency_av = [Double]()
    var dates = [String]()
    
    var discussionId = ""
    
//    let tableView = UITableView()
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
    
    private let changeTimeGraph: UIButton = {
        let button = UIButton()
        button.setTitle("average time", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTapChangeTimeGraph), for: .touchUpInside)
        return button
    }()
    
    private let changeFreqGraph: UIButton = {
        let button = UIButton()
        button.setTitle("average freq", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTapChangeFreqGraph), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Student Record: \(name)"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 41)
        label.textColor = .black
        return label
    }()
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dates"
        label.font = UIFont(name: "NotoSansKannada-Bold", size: 16)
        label.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        return label
    }()
    
    lazy var tableTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Data"
        label.font = UIFont(name: "NotoSansKannada-regular", size: 28)
        label.textColor = .black
        return label
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Student Record"
        view.backgroundColor = .white
        
        lineChart_time.delegate = self
        lineChart_freq.delegate = self
        
        view.addSubview(scrollView)
//        durationView, linesView,
        [ orangeView, greenView, lineChart_time, lineChart_freq, tablesTitleView, changeTimeGraph, pinkView,  changeFreqGraph].forEach{ scrollView.addSubview($0)}
        
        pinkView.addSubview(titleLabel)
        tablesTitleView.addSubview(tableTitleLabel)
        orangeView.addSubview(questionTableView)
        orangeView.addSubview(questionLabel)
        
        scrollView.isUserInteractionEnabled = true
        
        questionTableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.identifier)
        questionTableView.delegate = self
        questionTableView.dataSource = self
        
        self.setGraph()
        
        DispatchQueue.main.async {
            self.questionTableView.reloadData()
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width - 20, height: view.frame.size.height * 1.2)
        
        pinkView.frame = CGRect(x: 20, y: 20, width: 100, height: 60)
        
        //selected questions
        orangeView.anchor(top: pinkView.bottomAnchor, leading: nil, bottom: nil, trailing: scrollView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 100),size: .init(width: 320, height:250))

        //responnse type
        greenView.anchor(top: orangeView.bottomAnchor, leading: nil, bottom: nil, trailing: scrollView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 100), size: .init(width: 320, height: 350))
        
        tablesTitleView.anchor(top: pinkView.bottomAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0), size: .init(width: 100, height:40))
        
//        time
        lineChart_time.anchor(top: tablesTitleView.bottomAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0), size: .init(width: 600, height: 300))
        
        lineChart_time.layer.cornerRadius = 20
        lineChart_time.layer.borderColor = .init(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.3)
        lineChart_time.layer.borderWidth = 2

        
//      freq
        lineChart_freq.anchor(top: lineChart_time.bottomAnchor, leading: scrollView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 75, left: 30, bottom: 0, right: 0), size: .init(width: 600, height: 300))
        
        lineChart_freq.layer.cornerRadius = 20
        lineChart_freq.layer.borderColor = .init(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.3)
        lineChart_freq.layer.borderWidth = 2
        
//
        questionLabel.frame = CGRect(x: 0, y: 0, width: orangeView.width - 70, height: 20)
        questionTableView.frame =  CGRect(x: 0,
                                          y: questionLabel.bottom+2,
                                          width: orangeView.width,
                                          height: orangeView.height-22)
        
    
//        backButton.frame = CGRect(x:scrollView.width-210,
//                                  y: pinkView.top,
//                                   width: 150,
//                                   height: 42)
        
        changeTimeGraph.anchor(top: nil, leading: nil, bottom: lineChart_time.topAnchor, trailing: lineChart_time.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 150, height: 42))
        
        changeFreqGraph.anchor(top: nil, leading: nil, bottom: lineChart_freq.topAnchor, trailing: lineChart_freq.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 150, height: 42))
        
    }
    
    
    func timerFormat(seconds: Int) -> (Int, Int){
        return ((seconds/60),(seconds % 60)) //min , seconds
    }

    func makeTimeString(minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as! QuestionTableViewCell
        cell.configure(with: .red, question: dates[indexPath.row], time: nil)
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc private func didTapBack() {
        print("pressed")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangeTimeGraph(){
        if (changeTimeGraph.currentTitle! == "average time"){
            
            let line_Time_av_Set = LineChartDataSet(entries: lineEntries_time_av, label: "time av line chart")
            line_Time_av_Set.colors = ChartColorTemplates.material()
            let line_Time_av_Date = LineChartData(dataSet: line_Time_av_Set)
            lineChart_time.data = line_Time_av_Date
            lineChart_time.data?.notifyDataChanged()
            lineChart_time.notifyDataSetChanged()
            
            changeTimeGraph.setTitle("Speak Time", for: .normal)
        }
        else if (changeTimeGraph.currentTitle! == "Speak Time"){
            let line_Time_Set = LineChartDataSet(entries: lineEntries_time, label: "time line chart")
            line_Time_Set.colors = ChartColorTemplates.material()
            let line_Time_Date = LineChartData(dataSet: line_Time_Set)
            lineChart_time.data = line_Time_Date
            lineChart_time.data?.notifyDataChanged()
            lineChart_time.notifyDataSetChanged()
            
            changeTimeGraph.setTitle("average time", for: .normal)
        }
    }
    
    @objc private func didTapChangeFreqGraph(){
        if (changeFreqGraph.currentTitle! == "average freq"){
            
            let line_Frq_av_Set = LineChartDataSet(entries: lineEntries_freq_av, label: "freq av line chart")
            line_Frq_av_Set.colors = ChartColorTemplates.material()
            let line_Frq_av_Date = LineChartData(dataSet: line_Frq_av_Set)
            lineChart_freq.data = line_Frq_av_Date
            lineChart_freq.data?.notifyDataChanged()
            lineChart_freq.notifyDataSetChanged()
            
            changeFreqGraph.setTitle("Frequency", for: .normal)
        }
        else if (changeFreqGraph.currentTitle! == "Frequency"){
            let line_Frq_Set = LineChartDataSet(entries: lineEntries_freq, label: "freq line chart")
            line_Frq_Set.colors = ChartColorTemplates.material()
            let line_freq_Date = LineChartData(dataSet: line_Frq_Set)
            lineChart_freq.data = line_freq_Date
            lineChart_freq.data?.notifyDataChanged()
            lineChart_freq.notifyDataSetChanged()
            
            changeFreqGraph.setTitle("average freq", for: .normal)
        }
    }
    
    func setGraph(){
        
        var cnt = 0
        for time in speakTime{
            lineEntries_time.append(ChartDataEntry(x: Double(cnt), y: Double(time)))
            cnt+=1
        }
        
        cnt = 0
        for freq in speakFrequency{
            lineEntries_freq.append(ChartDataEntry(x: Double(cnt), y: Double(freq)))
            cnt+=1
        }
        
        cnt = 0
        for freq in speakFrequency_av{
            lineEntries_freq_av.append(ChartDataEntry(x: Double(cnt), y: freq))
            cnt+=1
        }
        
        cnt = 0
        for time in speakTime_av{
            lineEntries_time_av.append(ChartDataEntry(x: Double(cnt), y: time))
            cnt+=1
        }
        
        // 3. chart setup
        let line_Time_Set = LineChartDataSet(entries: lineEntries_time, label: "time line chart")
        line_Time_Set.colors = ChartColorTemplates.material()
        let line_Time_Date = LineChartData(dataSet: line_Time_Set)
        lineChart_time.data = line_Time_Date
        
        let line_Frq_Set = LineChartDataSet(entries: lineEntries_freq, label: "freq line chart")
        line_Frq_Set.colors = ChartColorTemplates.material()
        let line_freq_Date = LineChartData(dataSet: line_Frq_Set)
        lineChart_freq.data = line_freq_Date
        
    }
    
}
