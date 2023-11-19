//
//  BaseCollectionView.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit

open class BaseCollectionView: UICollectionView {
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
//        print("")
    }
    
    override open func reloadData() {
        super.reloadData()
        if let collectionViewLayout = collectionViewLayout as? CollectionViewFlowLayoutAble {
            collectionViewLayout.reload()
        }
    }
    
    public func zoomCell(at indexPath: IndexPath,
                          scaleX sx: CGFloat, y sy: CGFloat,
                          completion: BoolCallBack?) {
        performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            if let collectionViewLayout = self.collectionViewLayout as? CollectionViewFlowLayoutAble {
                self.cellForItem(at: indexPath)?.layer.zPosition = 1
                collectionViewLayout.zoomAttribute(at: indexPath, scaleX: sx, y: sy)
            }
        }, completion: completion)
    }
    
    public func move(at indexPath: IndexPath, pointX px: CGFloat, pointY py: CGFloat) {
        performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            if let collectionViewLayout = self.collectionViewLayout as? CollectionViewFlowLayoutAble {
                self.cellForItem(at: indexPath)?.layer.zPosition = 1
                collectionViewLayout.move(at: indexPath, pointX: px, pointY: py)
            }
        })
    }
    
    public func tranformCell(at indexPath: IndexPath, 
                             callBack: (UICollectionViewLayoutAttributes) -> Void,
                             completion: BoolCallBack?) {
        performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            if let collectionViewLayout = self.collectionViewLayout as? CollectionViewFlowLayoutAble {
                self.cellForItem(at: indexPath)?.layer.zPosition = 1
                collectionViewLayout.tranform(at: indexPath, callBack: callBack)
            }
        }, completion: completion)
    }
    
    public func identityCell(at indexPath: IndexPath) {
        performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            if let collectionViewLayout = self.collectionViewLayout as? CollectionViewFlowLayoutAble {
                self.cellForItem(at: indexPath)?.layer.zPosition = 0
                collectionViewLayout.identity(at: indexPath)
                self.reloadItems(at: [indexPath])
            }
        })
    }
}
