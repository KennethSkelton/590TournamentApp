//
//  ContentView.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack{
                MenuView(color : .red, label : "QR")
                    .navigationTitle("Home Page")
                    .offset(y:-60)
                
                NavigationLink("Go to QR", destination: ShowQRView())
            }
        }
    }
}

struct MenuView: View {
    
    var color : Color
    var label : String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
            Text("\(label)")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .bold))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
