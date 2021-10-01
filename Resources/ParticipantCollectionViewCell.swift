//
//  ParticipantCollectionViewCell.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/07/02.
//

import UIKit

class ParticipantCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
        
        static let identifier = "ParticipantCollectionViewCell"
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        public func configure(with image: UIImage, name: String){
            imageView.image = image
            nameLabel.text = name
        }
        //register cell
        static func nib() -> UINib {
            return UINib(nibName: "ParticipantCollectionViewCell", bundle:nil)
        }

}
