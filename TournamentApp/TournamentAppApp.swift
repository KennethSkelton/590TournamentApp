//
//  TournamentAppApp.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import SwiftUI
import RealmSwift

let app = RealmSwift.App(id: "590tournament-pgarn")

@main
struct TournamentAppApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
