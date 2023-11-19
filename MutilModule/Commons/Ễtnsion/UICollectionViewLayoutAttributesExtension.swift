//
//  UICollectionViewLayoutAttributesExtension.swift
//  Commons
//
//  Created by NguyenHao on 29/10/2023.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    public convenience init(forCellWith indexPath: IndexPath, frame: CGRect) {
        self.init(forCellWith: indexPath)
        self.frame = frame
    }
}

