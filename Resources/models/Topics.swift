//
//  Topics.swift
//  HarknessFirebase
//
//  Created by Su Yeon Lee on 2021/06/09.
//

import RealmSwift
import SwiftUI

class Topics: Object, Identifiable{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var topicName:String = ""
  //  @objc dynamic var topicTextId:[Int] = []
    override static func primaryKey() -> String? {
        return "id"
      }
}
