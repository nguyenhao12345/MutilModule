//
//  PHAssetExtension.swift
//  Commons
//
//  Created by NguyenHao on 29/10/2023.
//

import UIKit
import Photos

public extension PHAsset {
    func toImage() -> UIImage {
        var img: UIImage?
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .original
            options.isSynchronous = true

            manager.requestImageDataAndOrientation(for: self, options: options) { data, _, _, _ in
                if let data = data {
                    img = UIImage(data: data)
                }
            }
            return img ?? UIImage()
    }
    
    func scaleFactor(targetWidth: CGFloat) -> CGFloat {
        return targetWidth / CGFloat(pixelWidth)
    }
    
    func scaleFactor(targetHeight: CGFloat) -> CGFloat {
        return targetHeight / CGFloat(pixelHeight)
    }
}

public extension PHAsset {
    func toImage(targetWidth: CGFloat) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        option.resizeMode = .exact
        
        let scaleFactor = scaleFactor(targetWidth: targetWidth)
        let newHeight = CGFloat(pixelHeight) * scaleFactor
                                
        manager.requestImage(for: self, 
                             targetSize: CGSize(width: targetWidth,
                                                height: newHeight),
                             contentMode: .default,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func toImage(targetHeight: CGFloat) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        option.resizeMode = .exact
        
        let scaleFactor = scaleFactor(targetHeight: targetHeight)
        let newWidth = CGFloat(pixelWidth) * scaleFactor
                                
        manager.requestImage(for: self,
                             targetSize: CGSize(width: newWidth,
                                                height: targetHeight),
                             contentMode: .default,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
