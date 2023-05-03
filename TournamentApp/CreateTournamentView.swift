//
//  CreateTournamentView.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import SwiftUI
import RealmSwift

struct CreateTournamentView: View {
    
    @State var tournamentName : String = ""
    @State var tournamentType : String = ""
    
    @State var singlePlayer : String = ""
    @State var dataArray : [String] = []
    
    var userID : String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Please enter the name of the Tournament", text: $tournamentName)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .foregroundColor(.black)
                    .font(.headline)
                
         
                Picker("Format", selection: $tournamentType) {
                    Text("Round Robin").tag("RR")
                    Text("Single Elimination").tag("SE")
                    Text("Swiss").tag("SW")
                }
                .pickerStyle(.segmented)
                List{
                    ForEach(dataArray, id: \.self) { data in
                        Text(data)
                    }
                    .onDelete(perform: delete)
                }
                
                TextField("Please enter the name of a participant", text: $singlePlayer)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .foregroundColor(.black)
                    .font(.headline)
                
                Button(action: {
                    savePlayer()
                },label: {
                    Text("Add Participant")
                })
                Spacer()
                Button(action: {
                    persist()
                    dismiss()

                },label: {
                    Text("Save and post tournament")
                })
            }
        }
    }
    func savePlayer() {
        dataArray.append(singlePlayer)
        singlePlayer = ""
    }
    func delete(at offsets: IndexSet) {
            dataArray.remove(atOffsets: offsets)
        }
    
    func persist(){
        var players = [Player]()
        for name in dataArray{
            players.append(Player(name: name, record: nil))
        }
        
        createTournament(name: tournamentName, type: tournamentType, players: players, UserID: userID)
    }
}

struct CreateTournamentView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTournamentView()
    }
}

//import SwiftUI
//import RealmSwift
//
//
//struct RealmobjectView: View {
//        @ObservedObject var app: RealmSwift.App
//        var body: some View {
//            if let user = app.currentUser {
//                // If there is a logged in user, pass the user ID as the
//                // partitionValue to the view that opens a realm.
//                OpenSyncedRealmView().environment(\.partitionValue, user.id)
//            } else {
//                // If there is no user logged in, show the login view.
//                LoginView()
//            }
//        }
//}
//
//struct RealmobjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        RealmobjectView(app:app)
//    }
//}
//import RealmSwift
//import SwiftUI
//
//// MARK: MongoDB Realm (Optional)
//
//// The Realm app. Change YOUR_REALM_APP_ID_HERE to your Realm app ID.
//// If you don't have a Realm app and don't wish to use Sync for now,
//// you can change this to:
////   let app: RealmSwift.App? = nil
//// MARK: Models
//
///// Random adjectives for more interesting demo item names
//let randomAdjectives = [
//    "fluffy", "classy", "bumpy", "bizarre", "wiggly", "quick", "sudden",
//    "acoustic", "smiling", "dispensable", "foreign", "shaky", "purple", "keen",
//    "aberrant", "disastrous", "vague", "squealing", "ad hoc", "sweet"
//]
//
///// Random noun for more interesting demo item names
//let randomNouns = [
//    "floor", "monitor", "hair tie", "puddle", "hair brush", "bread",
//    "cinder block", "glass", "ring", "twister", "coasters", "fridge",
//    "toe ring", "bracelet", "cabinet", "nail file", "plate", "lace",
//    "cork", "mouse pad"
//]
//
//// MARK: Views
//
//// MARK: Main Views
///// The main screen that determines whether to present the SyncContentView or the LocalOnlyContentView.
//struct CreateTournamentView: SwiftUI.App {
//    var body: some Scene {
//        WindowGroup {
//            // Using Sync?
//            if let app = app {
//                SyncContentView(app: app)
//            } else {
//                LocalOnlyContentView(app: app)
//            }
//        }
//    }
//}
//
///// The main content view if not using Sync.
//struct LocalOnlyContentView: View {
//    @ObservedObject var app: RealmSwift.App
//
//    var body: some View {
//        if let user = app.currentUser {
//            // If there is a logged in user, pass the user ID as the
//            // partitionValue to the view that opens a realm.
//            OpenSyncedRealmView().environment(\.partitionValue, user.id)
//        } else {
//            // If there is no user logged in, show the login view.
//            LoginView()
//        }
//    }
//    // Implicitly use the default realm's objects(Group.self)
////    @ObservedResults(Group<Any>.self) var groups
////
////    var body: some View {
////        if let group = groups.first {
////            // Pass the Group objects to a view further
////            // down the hierarchy
////            ItemsView(group: group)
////        } else {
////            // For this small app, we only want one group in the realm.
////            // You can expand this app to support multiple groups.
////            // For now, if there is no group, add one here.
////            ProgressView().onAppear {
////                $groups.append(Group())
////            }
////        }
////    }
//}
//
///// This view observes the Realm app object.
///// Either direct the user to login, or open a realm
///// with a logged-in user.
//struct SyncContentView: View {
//    // Observe the Realm app object in order to react to login state changes.
//    @ObservedObject var app: RealmSwift.App
//
//    var body: some View {
//        if let user = app.currentUser {
//            // If there is a logged in user, pass the user ID as the
//            // partitionValue to the view that opens a realm.
//            OpenSyncedRealmView().environment(\.partitionValue, user.id)
//        } else {
//            // If there is no user logged in, show the login view.
//            LoginView()
//        }
//    }
//}
//
///// This view opens a synced realm.
//struct OpenSyncedRealmView: View {
//    // Use AsyncOpen to download the latest changes from
//    // your Realm app before opening the realm.
//    // Leave the `partitionValue` an empty string to get this
//    // value from the environment object passed in above.
//    @AsyncOpen(appId: "590tournament-pgarn", partitionValue: "590TournamentPartition", timeout: 4000) var asyncOpen
//
//    var body: some View {
//
//        switch asyncOpen {
//        // Starting the Realm.asyncOpen process.
//        // Show a progress view.
//        case .connecting:
//            ProgressView()
//        // Waiting for a user to be logged in before executing
//        // Realm.asyncOpen.
//        case .waitingForUser:
//            ProgressView("Waiting for user to log in...")
//        // The realm has been opened and is ready for use.
//        // Show the content view.
//        case .open(let realm):
//            CreateView(userRecipes: {
//                if realm.objects(tournament.self).count == 0 {
//                    try! realm.write {
//                        realm.add(tournament())
//                    }
//                }
//                return realm.objects(tournament.self).first!
//            }(), leadingBarButton: AnyView(LogoutButton())).environment(\.realm, realm)
//            // The realm is currently being downloaded from the server.
//            // Show a progress view.
//            case .progress(let progress):
//                ProgressView(progress)
//            // Opening the Realm failed.
//            // Show an error view.
//            case .error(let error):
//                ErrorView(error: error)
//        }
//    }
//}
//
//struct ErrorView: View {
//    var error: Error
//
//    var body: some View {
//        VStack {
//            Text("Error opening the realm: \(error.localizedDescription)")
//        }
//    }
//}
//
//// MARK: Authentication Views
///// Represents the login screen. We will have a button to log in anonymously.
//struct LoginView: View {
//    // Hold an error if one occurs so we can display it.
//    @State var error: Error?
//
//    // Keep track of whether login is in progress.
//    @State var isLoggingIn = false
//
//    var body: some View {
//        VStack {
//            if isLoggingIn {
//                ProgressView()
//            }
//            if let error = error {
//                Text("Error: \(error.localizedDescription)")
//            }
//            Button("Log in anonymously") {
//                // Button pressed, so log in
//                isLoggingIn = true
//                app.login(credentials: .anonymous) { result in
//                    isLoggingIn = false
//                    if case let .failure(error) = result {
//                        print("Failed to log in: \(error.localizedDescription)")
//                        // Set error to observed property so it can be displayed
//                        self.error = error
//                        return
//                    }
//                    // Other views are observing the app and will detect
//                    // that the currentUser has changed. Nothing more to do here.
//                    print("Logged in")
//                }
//            }.disabled(isLoggingIn)
//        }
//    }
//}
//
///// A button that handles logout requests.
//struct LogoutButton: View {
//    @State var isLoggingOut = false
//
//    var body: some View {
//        Button("Log Out") {
//            guard let user = app.currentUser else {
//                return
//            }
//            isLoggingOut = true
//            user.logOut() { error in
//                isLoggingOut = false
//                // Other views are observing the app and will detect
//                // that the currentUser has changed. Nothing more to do here.
//                print("Logged out")
//            }
//        }.disabled(app.currentUser == nil || isLoggingOut)
//    }
//}
//
//// MARK: Item Views
///// The screen containing a list of items in a group. Implements functionality for adding, rearranging,
///// and deleting items in the group.
//struct ItemsView: View {
//    /// The group is a container for a list of items. Using a group instead of all items
//    /// directly allows us to maintain a list order that can be updated in the UI.
//    @ObservedRealmObject var group: Group
//
//    /// The button to be displayed on the top left.
//    var leadingBarButton: AnyView?
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // The list shows the items in the realm.
//                List {
//                    ForEach(group.items) { item in
//                        ItemRow(item: item)
//                    }.onDelete(perform: $group.items.remove)
//                    .onMove(perform: $group.items.move)
//                }.listStyle(GroupedListStyle())
//                    .navigationBarTitle("Items", displayMode: .large)
//                    .navigationBarBackButtonHidden(true)
//                    .navigationBarItems(
//                        leading: self.leadingBarButton,
//                        // Edit button on the right to enable rearranging items
//                        trailing: EditButton())
//
//                // Action bar at bottom contains Add button.
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        // The bound collection automatically
//                        // handles write transactions, so we can
//                        // append directly to it.
//                        $group.items.append(Item())
//                    }) { Image(systemName: "plus") }
//                }.padding()
//            }
//        }
//    }
//}
//struct TournamentView: View {
//    /// The group is a container for a list of items. Using a group instead of all items
//    /// directly allows us to maintain a list order that can be updated in the UI.
//    @ObservedRealmObject var userRecipes:
//
//    /// The button to be displayed on the top left.
//    var leadingBarButton: AnyView?
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // The list shows the items in the realm.
//                List {
//                    ForEach(userRecipes.recipes) { item in
//                        RecipeRow(recipe: item)
//                    }.onDelete(perform: $userRecipes.recipes.remove)
//                    .onMove(perform: $userRecipes.recipes.move)
//                }.listStyle(GroupedListStyle())
//                    .navigationBarTitle("Recipes", displayMode: .large)
//                    .navigationBarBackButtonHidden(true)
//                    .navigationBarItems(
//                        leading: self.leadingBarButton,
//                        // Edit button on the right to enable rearranging items
//                        trailing: EditButton())
//
//                // Action bar at bottom contains Add button.
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        // The bound collection automatically
//                        // handles write transactions, so we can
//                        // append directly to it.
//                        $userRecipes.recipes.append(RecipeObjectIten())
//                    }) { Image(systemName: "plus") }
//                }.padding()
//            }
//        }
//    }
//}
////
/////// Represents an Item in a list.
////struct ItemRow: View {
////    @ObservedRealmObject var item: Item
////
////    var body: some View {
////        // You can click an item in the list to navigate to an edit details screen.
////        NavigationLink(destination: ItemDetailsView(item: item)) {
////            Text(item.name)
////            if item.isFavorite {
////                // If the user "favorited" the item, display a heart icon
////                Image(systemName: "heart.fill")
////            }
////        }
////    }
////}
//struct RecipeRow: View {
//    @ObservedRealmObject var recipe: RecipeObjectIten
//
//    var body: some View {
//        // You can click an item in the list to navigate to an edit details screen.
//        NavigationLink(destination: RecipeDetailsView(recipe:recipe)) {
//            Text(recipe.recipeName)
//            if item.isFavorite {
//                // If the user "favorited" the item, display a heart icon
//                Image(systemName: "heart.fill")
//            }
//        }
//    }
//}
/////// Represents a screen where you can edit the item's name.
////struct ItemDetailsView: View {
////    @ObservedRealmObject var item: Item
////
////    var body: some View {
////        VStack(alignment: .leading) {
////            Text("Enter a new name:")
////            // Accept a new name
////            TextField("New name", text: $item.name)
////                .navigationBarTitle(item.name)
////                .navigationBarItems(trailing: Toggle(isOn: $item.isFavorite) {
////                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
////                })
////        }.padding()
////    }
////}
////struct RecipeDetailsView: View {
////    @ObservedRealmObject var recipe: RecipeObjectIten
////
////    var leadingBarButton: AnyView?
////
////    var body: some View {
////        VStack(alignment: .leading) {
////            Text("Enter a new name:")
////            // Accept a new name
////            TextField("New name", text: $recipe.recipeName)
////                .navigationBarTitle(recipe.recipeName)
//////                .navigationBarItems(trailing: Toggle(isOn: $item.isFavorite) {
//////                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
//////                })
////        }
////        Spacer()
////        List {
////            ForEach(recipe.ingredients) { item in
////                IngredientDetailsView(ingredient: item)
////            }.onDelete(perform: $recipe.ingredients.remove)
////                .onMove(perform: $recipe.ingredients.move)
////        }.listStyle(GroupedListStyle())
////            .navigationBarTitle("Ingredients", displayMode: .large)
////            .navigationBarBackButtonHidden(true)
////            .navigationBarItems(
////                leading: self.leadingBarButton,
////                // Edit button on the right to enable rearranging items
////                trailing: EditButton())
////        Spacer()
////        List {
////            ForEach(recipe.instructions) { item in
////                InstructionDetailsView(instruction: item)
////            }.onDelete(perform: $recipe.instructions.remove)
////                .onMove(perform: $recipe.instructions.move)
////        }.listStyle(GroupedListStyle())
////            .navigationBarTitle("Instructions", displayMode: .large)
////            .navigationBarBackButtonHidden(true)
////            .navigationBarItems(
////                leading: self.leadingBarButton,
////                // Edit button on the right to enable rearranging items
////                trailing: EditButton())
//////        // Action bar at bottom contains Add button.
//////        HStack {
//////            Spacer()
//////            Button(action: {
//////                // The bound collection automatically
//////                // handles write transactions, so we can
//////                // append directly to it.
//////                $recipe.ingredients.append(IngredientObject())
//////            }) { Image(systemName: "plus") }
//////        }.padding()
//////    }
////        HStack {
////            Spacer()
////            Button(action: {
////                // The bound collection automatically
////                // handles write transactions, so we can
////                // append directly to it.
////                $recipe.instructions.append(InstructionObject())
////            }) { Image(systemName: "plus") }
////        }.padding()
////}
////struct IngredientDetailsView: View {
////    @ObservedRealmObject var ingredient: IngredientObject
////    var body: some View {
////        VStack(alignment: .leading) {
////            Text("Enter Ingredient:")
////            // Accept a new name
////            TextField("New name", text: $ingredient.ingredient)
////                .navigationBarTitle(ingredient.ingredient)
////
//////                .navigationBarItems(trailing: Toggle(isOn: $item.isFavorite) {
//////                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
//////                })
////        }.padding()
////    }
////}
////    struct InstructionDetailsView: View {
////        @ObservedRealmObject var instruction: InstructionObject
////        var body: some View {
////            VStack(alignment: .leading) {
////                Text("Enter Instruction:")
////                // Accept a new name
////                TextField("Insturction name", text: $instruction.instruction)
////                    .navigationBarTitle(instruction.instruction)
////                TextField("timer duration", text: $instruction.timerDuration)
////                    .navigationBarTitle(instruction.timerDuration)
////
////    //                .navigationBarItems(trailing: Toggle(isOn: $item.isFavorite) {
////    //                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
////    //                })
////            }.padding()
////        }
////    }
////}
