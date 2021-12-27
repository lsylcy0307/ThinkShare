//
//  ResponseCollectionViewCell.swift
//  ThinkShare
//
//  Created by Su Yeon Lee on 2021/12/18.
//

import UIKit

class ResponseCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResponseCollectionViewCell"
    
    private let typeLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "agreement"
        return label
    }()
    
    private let CountLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.text = "5"
        return label
    }()
    
    private let timeLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "times"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
        contentView.addSubview(typeLabel)
        contentView.addSubview(CountLabel)
        contentView.addSubview(timeLabel)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        typeLabel.frame = CGRect(x: 10, y: 10, width: contentView.frame.width, height: 20)
        CountLabel.frame = CGRect(x: 10, y: contentView.frame.height - 60, width: 30, height: 54)
        timeLabel.frame = CGRect(x: CountLabel.right + 10, y: CountLabel.bottom - 10, width: 30, height: 15)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    public func configure(type: String, count: Int, color: UIColor){
        typeLabel.text = type
        CountLabel.text = "\(count)"
        contentView.backgroundColor = color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeLabel.text = nil
        CountLabel.text = nil
    }
}
