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
    
    @IBOutlet weak var setTimerStack: UIStackView!
    @IBOutlet weak var questionField: UITextField!
    private var selectedQ = String()
    public var selectedQuestions = [String]()
    private var questions = [String]()
    private var newquestions = [String]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var QuestionView: UIView!
    var firstq = false
    var usedquestions = [String]()
    
    var minute = 5 //default time = 5 min
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        newquestions = []
        minuteLabel.text = "05"
        super.viewDidLoad()
        
        QuestionView.layer.cornerRadius = 10
        QuestionView.layer.borderWidth = 10
        QuestionView.layer.borderColor = CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1)
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = CGColor(red: 87/255, green: 149/255, blue: 149/255, alpha: 1)
        
        view.layer.cornerRadius = 12
        
        print("pop up  loaded")
        print(usedquestions)
        
        if firstq == false{
            setTimerStack.isHidden = false
        }
        else if firstq == true{
            setTimerStack.isHidden = true
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.loadQuestions()
    }
    
    @IBAction func addQuestion(_ sender: Any) {
        let question = questionField.text!
        newquestions.append(question)
        questions.append(question)
        collectionView.reloadData()
        questionField.text = ""
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
        
        NotificationCenter.default.post(name: DiscussionViewController.questionNotification, object: nil, userInfo: ["question": selectedQ, "new_questions": newquestions, "time" : minute])
        
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
//        Cell.contentView.layer.cornerRadius = 10
//        Cell.layer.shadowColor = UIColor.gray.cgColor
//        Cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        Cell.layer.shadowOpacity = 1.0
//        Cell.layer.shadowRadius = 2.0
//        Cell.layer.masksToBounds = false
//        Cell.layer.shadowPath = UIBezierPath(roundedRect:Cell.bounds, cornerRadius:Cell.contentView.layer.cornerRadius).cgPath
        
        return Cell
    }
}

