//
//  Functions.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import Foundation
import RealmSwift

func createUser(password: String, username: String) -> String {
    // Open the local-only default realm
    let userObject = User(password: password, username: username)
    let user = app.currentUser!
       // The partition determines which subset of data to access.
       let partitionValue = "590TournamentPartition"
       // Get a sync configuration from the user object.
       var configuration = user.configuration(partitionValue: partitionValue)
       // Open the realm asynchronously to ensure backend data is downloaded first.
       Realm.asyncOpen(configuration: configuration) { (result) in
           switch result {
           case .failure(let error):
               print("Failed to open realm: \(error.localizedDescription)")
               // Handle error...
           case .success(let realm):
               // Realm opened
               print("Realm Opened")
               try! realm.write {
                   realm.add(userObject)
               }
           }
       }
    return userObject._id
}
func createPlayer(name: String, record: Float?) {
    // Open the local-only default realm
    let realm = try! Realm()
    let player = Player(name: name, record: record)
    try! realm.write {
        realm.add(player)
    }
}
func createTournament(name: String, type: String, players: [Player], UserID: String) {
    // Open the local-only default realm
    let realm = try! Realm()
    let tournament = tournament(name: name, type: type, UserID: UserID)
    
    for player in players{
        tournament.players.append(player)
        tournament.pairings.append(player)
    }
    
    
    let user = app.currentUser!
       // The partition determines which subset of data to access.
       let partitionValue = "590TournamentPartition"
       // Get a sync configuration from the user object.
    let configuration = user.configuration(partitionValue: partitionValue)
       // Open the realm asynchronously to ensure backend data is downloaded first.
       Realm.asyncOpen(configuration: configuration) { (result) in
           switch result {
           case .failure(let error):
               print("Failed to open realm: \(error.localizedDescription)")
               // Handle error...
           case .success(let realm):
               // Realm opened
               print("Realm Opened")
               try! realm.write {
                   realm.add(tournament)
               }
           }
       }
    
}
