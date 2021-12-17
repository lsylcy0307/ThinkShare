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
        label.font = .systemFont(ofSize: 50, weight: .bold)
        return label
    }()
    
    private let teacherLabel: UILabel = {
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
        contentView.addSubview(textCodeLabel)
        contentView.addSubview(teacherLabel)
        self.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 198/255, alpha: 1)
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
        teacherLabel.frame = CGRect(x: contentView.right - 350,
                                     y: 20,
                                     width: 300,
                                     height: 50)
    }

    public func configure(with model: registeredSetting) {
        textCodeLabel.text = model.code
        teacherLabel.text = model.teacherName
    }

}
