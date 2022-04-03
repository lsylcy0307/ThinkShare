//
//  QuestionTableViewCell.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/12/17.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    static let identifier = "QuestionTableViewCell"
    
//    private let ImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 50
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let TimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(ImageView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(TimeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        ImageView.frame = CGRect(x: 10,
//                                     y: 10,
//                                     width: 20,
//                                     height: 20)
        
        questionLabel.frame = CGRect(x: 0,
                                     y: 10,
                                     width: contentView.width - 85,
                                     height: 20)
        
        TimeLabel.frame = CGRect(x: questionLabel.right + 10,
                                        y: 10,
                                        width: 75,
                                        height: 20)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with color:UIColor, question: String, time: Int?) {
        var timeString = ""
        if (time==nil){
            timeString = ""
        }
        else{
            let time_second = timerFormat(seconds: time!)
            timeString = makeTimeString(minutes: time_second.0, seconds: time_second.1)
        }
        
//        ImageView.layer.borderColor = CGColor(red: 106, green: 106, blue: 106, alpha: 1)
//        ImageView.layer.borderWidth = 1
        questionLabel.text = question
        TimeLabel.text = "🕑" + timeString
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
}
