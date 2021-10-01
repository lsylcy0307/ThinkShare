//
//  topicsCollectionViewCell.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/07/01.
//

import UIKit

class topicsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(with topicName:String){
        label.text = topicName
    }
}
