//
//  ShowQRView.swift
//  TournamentApp
//
//  Created by Kenneth Skelton on 4/29/23.
//
import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct ShowQRView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var imageSeed = "String"
    
    var body: some View {
        Image(uiImage: generateQRCodeImage(imageSeed)).interpolation(.none).resizable().frame(width:150, height: 150, alignment: .center)
    }
    
    func generateQRCodeImage(_ string: String) -> UIImage{
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        
        return UIImage(systemName: "xmark") ?? UIImage()
        
    }
}

struct ShowQRView_Previews: PreviewProvider {
    static var previews: some View {
        ShowQRView()
    }
}
