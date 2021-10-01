//
//  Questions.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/06/09.
//

import RealmSwift
import SwiftUI

class Questions: Object, Identifiable{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var question:String = ""
    @objc dynamic var text: topicText?
    override static func primaryKey() -> String? {
        return "id"
      }
}
