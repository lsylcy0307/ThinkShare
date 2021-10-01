//
//  infoTableViewCell.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/07/29.
//

import UIKit

class infoTableViewCell: UITableViewCell {

    static let identifier = "infoTableViewCell"
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    private let infoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(infoImageView)
        contentView.addSubview(infoTitleLabel)
        contentView.addSubview(infoDescriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)
        
        infoTitleLabel.frame = CGRect(x: infoImageView.right + 10,
                                     y: 10,
                                     width: contentView.width - 20 - infoImageView.width,
                                     height: (contentView.height-20)/2)
        
        infoDescriptionLabel.frame = CGRect(x: infoImageView.right + 10,
                                        y: infoTitleLabel.bottom + 5,
                                        width: contentView.width - 20 - infoImageView.width,
                                        height: (contentView.height-30)/2)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with image:UIImage, title: String, description: String) {
        infoTitleLabel.text = title
        infoDescriptionLabel.text = description
        infoImageView.image = image
    }


}
