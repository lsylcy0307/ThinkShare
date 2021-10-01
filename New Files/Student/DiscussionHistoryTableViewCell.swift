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
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(discussionNameLabel)
        contentView.addSubview(dateLabel)
        self.backgroundColor = UIColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        discussionNameLabel.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 300,
                                     height: 60)
        dateLabel.frame = CGRect(x: discussionNameLabel.right + 20,
                                     y: 10,
                                     width: contentView.width - 30 - discussionNameLabel.width,
                                     height: 30)
    }

    public func configure(with model: discussionHistory) {
        discussionNameLabel.text = model.name
        dateLabel.text = model.date
    }

}
