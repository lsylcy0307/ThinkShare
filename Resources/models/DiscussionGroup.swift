import RealmSwift
import SwiftUI
import Foundation

class DiscussionGroup: Object, Identifiable{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var groupName:String = ""
    @objc dynamic var numGirls:Int = 0
    @objc dynamic var numBoys:Int = 0
    @objc dynamic var totalParticipant:Int = 0
    @objc dynamic var roomType:String = ""
    
}
