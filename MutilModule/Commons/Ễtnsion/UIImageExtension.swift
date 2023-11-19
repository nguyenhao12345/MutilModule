//
//  UIImageExtension.swift
//  Commons
//
//  Created by NguyenHao on 18/11/2023.
//

import UIKit

public extension UIImage {
    func heightOfImage(with targetWidth: CGFloat) -> CGFloat {
        let scaleFactor = targetWidth / size.width
        let newHeight = size.height * scaleFactor
        return newHeight
    }
}
