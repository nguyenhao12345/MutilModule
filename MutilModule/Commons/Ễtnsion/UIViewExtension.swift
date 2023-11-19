//
//  UIViewExtension.swift
//  Commons
//
//  Created by NguyenHao on 22/10/2023.
//

import UIKit

public protocol ZoomAble: UIView {
    func actionZoom(duration: TimeInterval, animation: @escaping VoidCallBack, completion: ((Bool) -> Void)?)
}

public extension UIView {

}
