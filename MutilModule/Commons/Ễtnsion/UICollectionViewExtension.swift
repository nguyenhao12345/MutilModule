//
//  UICollectionViewExtension.swift
//  Commons
//
//  Created by NguyenHao on 01/11/2023.
//

import UIKit

public extension UICollectionView {
    func frameOfCollectionViewCell(at indexPath: IndexPath) -> CGRect? {
        guard let attributes = layoutAttributesForItem(at: indexPath) else { return nil }
        return convert(attributes.frame, to: superview)
    }
}
