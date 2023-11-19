//
//  CGPointExtension.swift
//  Commons
//
//  Created by NguyenHao on 05/11/2023.
//

import Foundation

public extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
