//
//  classes.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import Foundation
import RealmSwift

class Player: Object {
    @Persisted var _id = UUID().uuidString
    @Persisted var name: String
    @Persisted var record: Float?
    convenience init(name: String, record: Float?){
        
        self.init()
        self.name = name
        self.record = record ?? 0
        
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
class tournament: Object {
    @Persisted var _id = UUID().uuidString
    @Persisted var name: String?
    @Persisted var UserID: String?
    @Persisted var type: String?
    @Persisted var round: Int?
    @Persisted var pairings: List<Player>
    @Persisted var players: List<Player>
    
    convenience init(name: String, type: String, UserID: String){
        
        self.init()
        self.name = name
        self.type = type
        self.round = 0
        self.UserID = UserID
        
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
class User: Object {
    
    @Persisted var _id: String
    @Persisted var password: String?
    @Persisted var username: String?
    
    convenience init(password: String, username: String){
        
        self.init()
        self._id = app.currentUser?.id ?? "NONE"
        self.password = password
        self.username = username
        
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}

final class Item: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. primaryKey: true declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The name of the Item, By default, a random name is generated.
    @Persisted var name = "name"
    /// A flag indicating whether the user "favorited" the item.
    @Persisted var isFavorite = false
    /// The backlink to the Group this item is a part of.
    @Persisted(originProperty: "items") var group: LinkingObjects<Group>
}
/// Represents a collection of items.7u
final class Group: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Group. primaryKey: true declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The collection of Items in this group.
    @Persisted var items = RealmSwift.List<Item>()
}
