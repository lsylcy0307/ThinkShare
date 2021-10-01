import UIKit
import FirebaseFirestore

class QuestionPopViewController: UIViewController {
    private let database = Firestore.firestore()
    
    var callback: ((Int?)->())?
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var addToMin: UIButton!
    @IBOutlet weak var subToMin: UIButton!
    @IBOutlet weak var Reset: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private var selectedQ = String()
    public var selectedQuestions = [String]()
    private var questions = [String]()
    
    var firstq = false
    var usedquestions = [String]()
    
    var minute = 5 //default time = 5 min
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        minuteLabel.text = "05"
        super.viewDidLoad()
        
        view.layer.cornerRadius = 12
        
        print("pop up  loaded")
        print(usedquestions)
        
        if firstq == false{
            stackView.isHidden = false
        }
        else if firstq == true{
            stackView.isHidden = true
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.loadQuestions()
    }
    
    @IBAction func addMin(_ sender: Any) {
        var minTime = ""
        if(minute<60){
            minute += 1
        }
        if (minute>=0 && minute<10){
            minTime = "0" + String(minute)
        }
        else {
            minTime = String(minute)
        }
        minuteLabel.text = minTime
    }
    
    @IBAction func subMin(_ sender: Any) {
        var minTime = ""
        if(minute>=1){
            minute -= 1
        }
        if (minute>=0 && minute<10){
            minTime = "0" + String(minute)
        }
        else {
            minTime = String(minute)
        }
        minuteLabel.text = minTime
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        minute = 5
        minuteLabel.text = "05"
        secondLabel.text = "00"
    }
    
    func QuestionstoView(){
        self.collectionView.reloadData()
    }
    
    func loadQuestions(){
        self.questions = []
        for question in selectedQuestions {
            self.questions.append(question)
        }
        self.QuestionstoView()
    }
}

extension QuestionPopViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedQ = questions[indexPath.row]
        
        NotificationCenter.default.post(name: DiscussionViewController.questionNotification, object: nil, userInfo: ["question": selectedQ])
        
        if firstq == false {
            callback?(minute)
            print("completionHandler returns... ")
        }
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! questionsCollectionViewCell
        Cell.configure(with: questions[indexPath.row])
        return Cell
    }
}

