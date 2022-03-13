//
//  DiscussionHistoryTableViewCell.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/09/26.
//

import UIKit

class DiscussionHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "DiscussionHistoryTableViewCell"
    
    private let discussionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.textColor = UIColor(cgColor: CGColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1))
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(discussionNameLabel)
        contentView.addSubview(dateLabel)
        self.backgroundColor = UIColor(red: 253/255, green: 242/255, blue: 231/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        discussionNameLabel.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 500,
                                     height: 60)
        dateLabel.frame = CGRect(x: contentView.right - 250,
                                 y: 20,
                                 width: 200,
                                 height: 50)
    }

    public func configure(with model: discussionHistory) {
        discussionNameLabel.text = model.name
        dateLabel.text = model.date
    }

}
