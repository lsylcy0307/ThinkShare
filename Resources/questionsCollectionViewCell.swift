//
//  questionsCollectionViewCell.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/07/02.
//

import UIKit

class questionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    
    func configure(with qName:String){
        label.adjustsFontSizeToFitWidth = true
        label.text = qName
    }
}
