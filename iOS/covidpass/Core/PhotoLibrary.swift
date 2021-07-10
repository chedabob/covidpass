//
//  PhotoLibrary.swift
//  covidpass
//
//  Created by Matt Malone on 27/06/2021.
//

import Foundation
import Photos
import UIKit

protocol PhotoLibrary {
    typealias AuthCallback = (()->())
    typealias GetCallBack = ((UIImage?)->())
    func getLatestQRScreenshot(with callback: @escaping GetCallBack)
    func requestAuthorization(with callback: @escaping AuthCallback)
    var isAuthorized: Bool { get }
    var canRequestAuthorization: Bool { get }
}

class PhotoLibraryImpl: PhotoLibrary {
    var isAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus() == .authorized
    }

    var canRequestAuthorization: Bool {
        PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    private let imageManager = PHImageManager()

    func getLatestQRScreenshot(with callback: @escaping GetCallBack) {
        guard isAuthorized else {
            callback(nil)
            return
        }

        let optionForallPhotos = PHFetchOptions()
        optionForallPhotos.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        optionForallPhotos.fetchLimit = 10
        let assets = PHAsset.fetchAssets(with: .image, options: optionForallPhotos)
        var qrAsset: PHAsset?
        assets.enumerateObjects { asset, _, stop in
            if asset.mediaSubtypes.contains(.photoScreenshot) {
                qrAsset = asset
                stop.pointee = true
            }
        }
        guard qrAsset != nil else {
            callback(nil)
            return
        }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none

        imageManager.requestImage(for: qrAsset!, targetSize: CGSize(width: 5000,height: 5000), contentMode: .default, options: options) { image, _ in
            callback(image)
        }
    }

    func requestAuthorization(with callback: @escaping AuthCallback) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                callback()
            }
        }
    }
}
