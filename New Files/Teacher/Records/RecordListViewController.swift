//
//  RecordListViewController.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2022/03/15.
//

import UIKit

struct participationRecord {
    let date: String
    let discussionId: String
    let frequency: Int
    let speakTime: Int
    let duration: Int
}


class RecordListViewController: UIViewController {
    public var classInfo:classrooms?
//    var record:[participationRecord]?
    weak var popDelegate:popClassVCDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        return button
    }()
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(classInfo)
        view.backgroundColor = .white
        view.tag = 9
        backButton.addTarget(self,
                             action: #selector(didTapBack),
                             for: .touchUpInside)
        view.addSubview(backButton)
        view.addSubview(tableView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.setupTableView()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 150, width: view.width, height: view.height-150)
        backButton.frame = CGRect(x: 20,
                                  y: 80,
                                  width: 200,
                                  height: 50)
//        noSettingsLabel.frame = CGRect(x: 10,
//                                          y: (view.height-100)/2,
//                                          width: view.width-20,
//                                          height: 100)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getRecords(){
    }
    
    @objc private func didTapBack(){
        popDelegate?.onPopView()
    }
    
}
extension RecordListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(classInfo!.students.count)
        return classInfo!.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = classInfo!.students[indexPath.row]
        cell.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1)
        cell.textLabel?.font = UIFont(name: "ArialMT", size: 20)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStu = classInfo!.students[indexPath.row]
        self.loadStudentRecord(studentName: selectedStu)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
    
    private func loadStudentRecord(studentName: String){
        DatabaseManager.shared.getStudentRecord(with: classInfo!.code, name: studentName, completion:  { [weak self] result in
            switch result {
            case .success(let records):
                self?.sendToView(records: records, name: studentName)
            case .failure(let error):
                print("failed to get record: \(error)")
                //does not have a statistic
            }
        })
    }
    
    private func sendToView(records:[participationRecord], name: String){
        var duration:[Int]=[]
        var frequncy:[Int]=[]
        var speakTime:[Int]=[]
        var frequncy_av:[Double]=[]
        var speakTime_av:[Double]=[]
        var dates:[String] = []
        
        for record in records {
            duration.append(record.duration)
            frequncy.append(record.frequency)
            speakTime.append(record.speakTime)
            let freq_av = Double(record.frequency)/Double(record.duration)
            let time_av = Double(record.speakTime)/Double(record.duration)
            let roundedValue_freq = round(freq_av * 100) / 100.0
            let roundedValue_time = round(time_av * 100) / 100.0
            
            speakTime_av.append(roundedValue_time)
            frequncy_av.append(roundedValue_freq)
            dates.append(record.date)
        }
        
        let recordVC = recordViewController()
        recordVC.speakTime = speakTime
        recordVC.speakFrequency = frequncy
        recordVC.speakTime_av = speakTime_av
        recordVC.speakFrequency_av = frequncy_av
        recordVC.dates = dates
        recordVC.name = name
        
        navigationController?.pushViewController(recordVC, animated: true)
    }
    
}
