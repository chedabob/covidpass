//
//  LoadPassUseCase.swift
//  covidpass
//
//  Created by Matt Malone on 27/06/2021.
//

import CoreImage
import Foundation
import UIKit

class LoadPassUseCase {
    typealias LoadPassCallback = ((Pass)->())
    let photoLibrary: PhotoLibrary
    let network: Network
    let wallet: Wallet
    
    init(photoLibrary: PhotoLibrary, network: Network, wallet: Wallet) {
        self.photoLibrary = photoLibrary
        self.network = network
        self.wallet = wallet
    }
    
    func run(with callback: @escaping LoadPassCallback) {
        photoLibrary.getLatestQRScreenshot { image in
            if let image = image,
               let features = self.detectQRCode(image),
               let qr = features.first as? CIQRCodeFeature,
               let message = qr.messageString {
                self.network.getPass(from: message) { data, error in
                    guard let data = data else { return }
                    let pass = self.wallet.loadPass(with: data)
                    if  let pass = pass {
                        callback(pass)
                    }
                }
            }
        }
    }
    
    private func detectQRCode(_ image: UIImage) -> [CIFeature]? {
        if let ciImage = CIImage(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
        }
        return nil
    }
}
