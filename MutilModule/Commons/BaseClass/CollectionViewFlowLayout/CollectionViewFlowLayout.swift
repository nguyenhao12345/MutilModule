//
//  CollectionViewFlowLayout.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit

public enum CollectionViewFlowLayoutState: Int  {
    case prepare = 0
    case calculated = 1
}

public enum FlowLayoutStyle {
    case horizontal
    case vertical
    case custom(CollectionViewLayoutAttributedManagerProtocol)
}

extension CollectionViewFlowLayoutState: Comparable {
    public static func < (lhs: CollectionViewFlowLayoutState, rhs: CollectionViewFlowLayoutState) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
public protocol CollectionViewFlowLayoutAble: NSObject {
    func reload()
    func zoomAttribute(at indexPath: IndexPath, scaleX sx: CGFloat, y sy: CGFloat)
    func move(at indexPath: IndexPath, pointX px: CGFloat, pointY py: CGFloat)
    func tranform(at indexPath: IndexPath,
                             callBack: (UICollectionViewLayoutAttributes) -> Void)
    func identity(at indexPath: IndexPath)
    func contentSize(at indexPath: IndexPath) -> CGSize?
}

public class CollectionViewFlowLayout: UICollectionViewFlowLayout, CollectionViewFlowLayoutAble {
    private var collectionViewFlowLayoutAttributedManager: CollectionViewLayoutAttributedManagerProtocol?
    private var state = CollectionViewFlowLayoutState.prepare

    public init(delegate: CollectionViewFlowLayoutDelegate?,
                collectionView: UICollectionView,
                flowLayoutStyle: FlowLayoutStyle) {
        super.init()
        switch flowLayoutStyle {
        case .horizontal:
            break
        case .vertical:
            collectionViewFlowLayoutAttributedManager = CollectionViewVerticalFlowLayoutAttributedManager(delegate: delegate,
                                                                  collectionView: collectionView)
        case .custom(_):
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        super.prepare()
        if state == .prepare {
            collectionViewFlowLayoutAttributedManager?.prepare()
            state = .calculated
        }
    }
    
    public func reload() {
        state = .prepare
        collectionViewFlowLayoutAttributedManager?.reload()
        prepare()
    }
    
    public override var collectionViewContentSize: CGSize {
        CGSize(width: collectionViewFlowLayoutAttributedManager?.widthContentSize() ?? collectionView?.frame.width ?? 0.0,
               height: collectionViewFlowLayoutAttributedManager?.heightContentSize() ?? collectionView?.frame.height ?? 0.0)
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        collectionViewFlowLayoutAttributedManager?.layoutAttributesForItem(at: indexPath)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return collectionViewFlowLayoutAttributedManager?.layoutAttributesForElements(in: rect)
    }
    
    public func zoomAttribute(at indexPath: IndexPath, scaleX sx: CGFloat, y sy: CGFloat) {
        collectionViewFlowLayoutAttributedManager?.zoom(at: indexPath, scaleX: sx, y: sy)
    }
    
    public func move(at indexPath: IndexPath, pointX px: CGFloat, pointY py: CGFloat) {
        collectionViewFlowLayoutAttributedManager?.move(at: indexPath, pointX: px, pointY: py)
    }
    
    public func tranform(at indexPath: IndexPath,
                             callBack: (UICollectionViewLayoutAttributes) -> Void) {
        collectionViewFlowLayoutAttributedManager?.tranform(at: indexPath,
                                                            callBack: callBack)
    }
    
    public func identity(at indexPath: IndexPath) {
        collectionViewFlowLayoutAttributedManager?.identity(at: indexPath)
    }
    
    public func contentSize(at indexPath: IndexPath) -> CGSize? {
        collectionViewFlowLayoutAttributedManager?.contentSize(at: indexPath)
    }
}

