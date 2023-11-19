//
//  UIWindowExtension.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit

public extension UIWindow {
    static var topViewController: UIViewController? {
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
                return topController
//            }
        }
        return nil
    }
}
