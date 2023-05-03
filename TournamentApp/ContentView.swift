//
//  ContentView.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State var isNotLoggedIn = true
    @State var username = ""
    @State var password = ""
    @State var userID = ""
    
    
    var loginView : some View {
        VStack{
            TextField("Please input Username", text: $username)
            TextField("Please input Password", text: $password)
            Button(action: {
                Task{
                    realmLogin(email: username, password: password)
                }
                retrieveID(username: username, password: password)
            },label: {
                Text("Login")
            })
            Button(action: {
                Task{
                    await realmSignup(email: username, password: password)
                }
                retrieveID(username: username, password: password)
            },label: {
                Text("Register")
            })
            
        }
        .background(Color.purple)
    }
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink("Create Tournament", destination: CreateTournamentView(userID: userID))
                NavigationLink("Manage Tournament", destination: ManageTournamentView())
                NavigationLink("View Tournament", destination: ViewTournamentView(userID: userID))
                NavigationLink("Go to Show QR", destination: ShowQRView())
                NavigationLink("Go to Scan QR", destination: ScanQRView())
                
                
                Text(username)
                Text(password)
                Text(userID)
                
                
            }
            .popover(isPresented: $isNotLoggedIn) {
                self.loginView
            }
        }
    }
        
    func realmSignup(email: String, password: String) async{

        let client = app.emailPasswordAuth
        let email = email
        let password = password

        do {
            try await client.registerUser(email: email, password: password)
            // Registering just registers. You can now log in.
            print("Successfully registered user.")
        } catch {
            print("Failed to register: \(error.localizedDescription)")
        }

    }
    
    func realmLogin(email: String, password: String){
        let credentials = Credentials.emailPassword(email: email, password: password)
        
        app.login(credentials: credentials) { (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
            case .success(let user):
                print("Successfully logged in as user \(user)")
            }
        }
    }
    
    
    func retrieveID(username: String, password: String){

        isNotLoggedIn = false
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        userID = app.currentUser?.id ?? "None"
        print("userID \(userID)")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
