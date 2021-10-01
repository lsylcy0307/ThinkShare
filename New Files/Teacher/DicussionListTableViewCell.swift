//
//  DicussionListTableViewCell.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/08/02.
//

import UIKit

class DicussionListTableViewCell: UITableViewCell {
    
    static let identifier = "ContactUsersTableViewCell"
    
    private let textCodeLabel: UILabel = {
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
        contentView.addSubview(textCodeLabel)
        contentView.addSubview(dateLabel)
        self.backgroundColor = UIColor(red: 253/255, green: 242/255, blue: 231/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textCodeLabel.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 300,
                                     height: 60)
        dateLabel.frame = CGRect(x: textCodeLabel.right + 20,
                                     y: 10,
                                     width: contentView.width - 30 - textCodeLabel.width,
                                     height: 30)
    }

    public func configure(with model: Setting) {
        textCodeLabel.text = model.code
        dateLabel.text = model.registeredDate
    }

}
