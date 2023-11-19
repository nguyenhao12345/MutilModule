//
//  PhotoPermission.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit
import Photos

public protocol PhotoPermission: AnyObject {
    func checkAuthorization(callback: @escaping (PHAuthorizationStatus) -> Void)
    func requestOpenSetting(title: String, message: String)
}

extension PhotoPermission {
    public func checkAuthorization(callback: @escaping (PHAuthorizationStatus) -> Void) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
//            requestOpenSetting(title: "Title", message: "Go to Settings?")
            
            if authorizationStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        callback(.authorized)
                    } else {
                        callback(status)
                    }
                })
            }
//            callback(.notDetermined)
        case .restricted:
            callback(.restricted)
        case .denied:
            if authorizationStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        callback(.authorized)
                    } else {
                        callback(status)
                    }
                })
            }
        case .authorized:
            callback(.authorized)
        case .limited:
            if #available(iOS 14, *) {
                callback(.limited)
            }
        @unknown default:
            break
        }
    }
    
    public func requestOpenSetting(title: String, message: String) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            UIApplication.shared.openSetting()
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        UIWindow.topViewController?.present(alertController, animated: true, completion: nil)
    }
}
