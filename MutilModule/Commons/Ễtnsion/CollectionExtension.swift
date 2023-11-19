//
//  CollectionExtension.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import Foundation

extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

