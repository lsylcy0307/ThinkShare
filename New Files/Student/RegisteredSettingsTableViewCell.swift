//
//  RegisteredSettingsTableViewCell.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/08/12.
//

import UIKit

class RegisteredSettingsTableViewCell: UITableViewCell {
    
    static let identifier = "RegisteredSettingsTableViewCell"
    
    private let textCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .semibold)
        return label
    }()
    
    private let teacherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textCodeLabel)
        contentView.addSubview(teacherLabel)
        self.backgroundColor = UIColor(red: 138/255, green: 43/255, blue: 226/255, alpha: 0.3)
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
        teacherLabel.frame = CGRect(x: textCodeLabel.right + 20,
                                     y: 10,
                                     width: contentView.width - 30 - textCodeLabel.width,
                                     height: 30)
    }

    public func configure(with model: registeredSetting) {
        textCodeLabel.text = model.code
        teacherLabel.text = model.teacherName
    }

}
