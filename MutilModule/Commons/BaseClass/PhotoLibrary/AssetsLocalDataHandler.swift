//
//  AssetsLocalDataHandler.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit
import Photos

public protocol RequestAssetsLocalData {
    func getImages(from folder: String, completion: @escaping (PHFetchResult<PHAsset>) -> Void)
}

open class AssetsLocalDataHandler: NSObject, RequestAssetsLocalData {
    public override init() {
        super.init()
    }
    
    public func getImages(from folder: String, completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
        let author = PHPhotoLibrary.authorizationStatus()
        if author == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "title = %@", folder)
                    let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                    guard let album = albums.firstObject else { return }
                    // Fetch all the assets (photos) in the album
                    let assets = PHAsset.fetchAssets(in: album, options: nil)
                    completion(assets)
                } else {}
            })
        } else if author == .authorized {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", folder)
            let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            guard let album = albums.firstObject else { return }
            // Fetch all the assets (photos) in the album
            let assets = PHAsset.fetchAssets(in: album, options: nil)
            completion(assets)
        } else {
            return
        }
    }
}
