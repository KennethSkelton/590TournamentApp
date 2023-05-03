//
//  ViewTournamentView.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import SwiftUI
import Algorithms
import RealmSwift

struct ViewTournamentView: View {
    
    
    
    @State var userID: String = ""
    
    @State var tournamentID: String = ""
    @State var nameIDDict: [String: String] = [:]
    @State var allTournaments: [[String: AnyBSON?]] = [[:]]
    @State var pairings : [Player] = []
    
    @State var pairs : [[[String]]] = [[[]]]
    @State var string1 : String = ""
    @State var string2 : String = ""
    
    @State var round : Int = 0
    
    @State var selectedName : String = ""
    @State var isDisplaySheet = false
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Select a Tournament")
                Picker(selection: $selectedName, label: Text("Tournament Name")){
                    ForEach(getKeys(), id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
                Button(action:{
                    isDisplaySheet = true
                }, label: {
                    Text("Show Pairings")
                })
            }
            .onAppear {
                getNameIDDict()
                }
            .onChange(of: selectedName){ _ in
                print("")
                getPlayers()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)){
                    makePairs()
                }
            }
            .sheet(isPresented: $isDisplaySheet){
                self.tournamentStandings
            }
        }
    }
    
    var tournamentStandings: some View {
        VStack{
            Text(selectedName)
            Text("Round: "+String(round))
            Text(string1)
            Text(string2)
    
            
            Button(action: {
                selectedName = ""
                isDisplaySheet = false
            }, label: {
                Text("Back")
                
            })
        }
    }
    
    func swapDisplay(){
        isDisplaySheet = true
    }
    
    func makePairs() {
        
        var pairList : [[Player]] = [[]]
        
        var tempPairings = pairings
        print("Pairings are  \(pairings)")
        print("Temp pairings are \(tempPairings)")
        while(tempPairings.count > 1){
            let pair = [tempPairings[0], tempPairings[1]]
            tempPairings.remove(at: 0)
            tempPairings.remove(at: 0)
            pairList.append(pair)
        }
        if (tempPairings.count > 0){
            pairList.append([tempPairings[0], Player(name: "BYE", record: 0)])
        }
        
        pairList.remove(at: 0)
        
        print("Pairs are \(pairList)")
        for pair in pairList{
            print("Pair is: \(pair)")
        }
        
        
        string1 = pairList[0][0].name + " " + String(pairList[0][0].record ?? 0) + " VS " + pairList[0][1].name + " " + String(pairList[0][1].record ?? 0)
    
        string2 = pairList[1][0].name + " " + String(pairList[1][0].record ?? 0) + " VS " + pairList[1][1].name + " " + String(pairList[1][1].record ?? 0)
        
        print(string1)
        print(string2)
        
        
    }
    
    func getTournamentInformation() {
        
        let UserID = nameIDDict[selectedName]
        
        Realm.asyncOpen(){ (result) in
            switch result {
            case .failure(let error):
                print("Failed to open realm: (error.localizedDescription)")
                // Handle error...
            case .success(let realm):
                // Realm opened
                print("Realm Opened")
                let Tournaments = realm.objects(tournament.self)
                print(Tournaments)
                let realmSwiftQuery = Tournaments.where {
                    ($0.UserID == UserID)
                }
                
                if realmSwiftQuery.count > 0{
                    round = realmSwiftQuery[0].round!
                }
                
            }
        }
    }
    
    func getKeys() -> [String]{
        var result : [String] = []
        
        for key in nameIDDict.keys{
            result.append(key)
        }
        return result
    }
    
    func getPlayers(){
        
        let name = selectedName
        let tournaments = allTournaments
        
        var foundTournament: [String: AnyBSON?]
        
        for tournament in tournaments {
            let tournamentName = BSONtoString(BSON:tournament["name"]!, mode: 1)
            
            print("found bson was \(String(describing: tournament["name"]))")
            print("found name was \(tournamentName)")
            
            if tournamentName.contains(name){
                foundTournament = tournament
                print("found tournament was \(foundTournament)")
                
                
                let pairingsString = String(describing:tournament["pairings"])
                
                
                var components = pairingsString.components(separatedBy: "\"")
                
                var i = 0
                
                while i < components.count{
                    if components[i].count != 36{
                        components.remove(at: i)
                        
                    }else{
                        i+=1
                    }
                }
                
                
                let client = app.currentUser!.mongoClient("mongodb-atlas")
                // Select the database
                let database = client.database(named: "TournamentUsers")
                // Select the collection
                let collection = database.collection(withName: "Player")
                
                for playerId in components{
                    let queryFilter: Document = ["_id": AnyBSON(stringLiteral: playerId)]
                    
                    collection.find(filter: queryFilter) { result in
                        switch result {
                        case .failure(let error):
                            print("Call to MongoDB failed: \(error.localizedDescription)")
                            return
                        case .success(let documents):
                            print("Results: ")
                            
                            for document in documents {
                                
                                print("Document is \(document)")
                            
                                var nameString = BSONtoString(BSON: document["name"]!, mode: 1)
                                
                                var recordString = BSONtoString(BSON: document["record"]!, mode: 2)
                                
                                print("Found player name: \(nameString)")
                                print("Found record string: \(recordString)")
                                
                                pairings.append(Player(name: nameString, record: Float(recordString)))
                                
                                
                            }
                            
                        }
                    }
                    
                }
                print("Pairings are: \(pairings)")
            }
        }
    }
    
    
    
    
    func getNameIDDict() {
        
        
        var dict : [String: String] = [:]
        
        
        let client = app.currentUser!.mongoClient("mongodb-atlas")
        // Select the database
        let database = client.database(named: "TournamentUsers")
        // Select the collection
        let collection = database.collection(withName: "tournament")
        
        
        
        let queryFilter: Document = ["UserID": AnyBSON(stringLiteral: userID)]
        
        collection.find(filter: queryFilter) { result in
            switch result {
            case .failure(let error):
                print("Call to MongoDB failed: \(error.localizedDescription)")
                return
            case .success(let documents):
                print("Results: ")
                allTournaments = documents
                for document in documents {
                    
                    var tempID = "\(String(describing: document[("_id")]))"
                    
                    var start = tempID.index(tempID.startIndex, offsetBy: 45)
                    var end = tempID.index(tempID.endIndex, offsetBy: -4)
                    var range = start..<end

                    var mySubstring = tempID[range]
                    
                    tempID = String(mySubstring)
                    
                    var tempName = "\(String(describing: document[("name")]))"
                    
                    start = tempName.index(tempName.startIndex, offsetBy: 45)
                    end = tempName.index(tempName.endIndex, offsetBy: -4)
                    range = start..<end

                    mySubstring = tempName[range]
                    
                    tempName = String(mySubstring)
                    dict[tempName] = tempID
                    print(dict)
                    
                    nameIDDict = dict
                }
            }
        }
    }
    
    func BSONtoString(BSON: AnyBSON?, mode: Int) -> String{
        
        print("BSON in function is \(BSON)")
        
        
        var offSet1 = 45
        var offSet2 = -4
        
        if mode == 1{
            offSet1 = 36
            offSet2 = -3
        }
        if mode == 2{
            offSet1 = 35
            offSet2 = -4
        }
        
        
        var tempID = "\(String(describing: BSON))"
        
        print("String in funcion is \(tempID)")
        
        var start = tempID.index(tempID.startIndex, offsetBy: offSet1)
        var end = tempID.index(tempID.endIndex, offsetBy: offSet2)
        var range = start..<end

        var mySubstring = tempID[range]
        
        return String(mySubstring)
        
        
    }
    
}


struct ViewTournamentView_Previews: PreviewProvider {
    static var previews: some View {
        ViewTournamentView()
    }
}
