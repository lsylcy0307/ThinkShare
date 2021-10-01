//
//  topicText.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/06/09.
//

import RealmSwift
import SwiftUI

class topicText: Object, Identifiable{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var textLink:String = ""
    @objc dynamic var topic: Topics?
    override static func primaryKey() -> String? {
        return "id"
      }
}
