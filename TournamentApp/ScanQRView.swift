//
//  ReadQRView.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//

import SwiftUI
import CodeScanner

struct ScanQRView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a QR code to get started"
    @State var shouldHide = true
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result{
                    self.scannedCode = code.string
                    self.isPresentingScanner = false
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
                Text(scannedCode)
                
                Button("Scan QR code") {
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner, onDismiss: didDismiss){
                    self.scannerSheet
                }
                
                NavigationLink("View Tournament", destination: ViewTournamentView(tournamentID: scannedCode))
                    .opacity(shouldHide ? 0 : 1)
            }
        }
    }
    
    func didDismiss(){
        shouldHide = false
    }
}



struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRView()
    }
}
