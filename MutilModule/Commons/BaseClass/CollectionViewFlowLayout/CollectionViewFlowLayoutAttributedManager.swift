//
//  CollectionViewFlowLayoutAttributedManager.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit

public protocol CollectionViewFlowLayoutDelegate: AnyObject {
    func marginHorizontal() -> CGFloat
    func marginVertical() -> CGFloat
    func numberColumnInCollection() -> Int
    func heightForCell(at indexPath: IndexPath, widthCellOfContent: CGFloat) -> CGFloat
}

public protocol CollectionViewLayoutAttributedManagerProtocol {
    var collectionView: UICollectionView? { get }
    var delegate: CollectionViewFlowLayoutDelegate? { get }
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    func heightContentSize() -> CGFloat
    func widthContentSize() -> CGFloat
    
    func prepare()
    func reload()
    func zoom(at indexPath: IndexPath, scaleX sx: CGFloat, y sy: CGFloat)
    func move(at indexPath: IndexPath, pointX px: CGFloat, pointY py: CGFloat)
    func tranform(at indexPath: IndexPath, callBack: (UICollectionViewLayoutAttributes) -> Void)
    func identity(at indexPath: IndexPath)
    func contentSize(at indexPath: IndexPath) -> CGSize?
}

open class CollectionViewFlowLayoutAttributedManager: NSObject, CollectionViewLayoutAttributedManagerProtocol {
    enum Direction {
        case top
        case bottom
        case none
    }
    
    public weak var delegate: CollectionViewFlowLayoutDelegate?
    public weak var collectionView: UICollectionView?
    var attributedsCached: [UICollectionViewLayoutAttributes] = []
    private lazy var scaningRect = CGRect(origin: .init(x: -(collectionView?.frame.width ?? 0),
                                                        y: -(collectionView?.frame.height ?? 0)),
                                          size: .init(width: 3 * (collectionView?.frame.width ?? 0),
                                                      height: 3 * (collectionView?.frame.height ?? 0)))
    private var indexOfMaxY = 0
    private var indexOfMinY = 0
    private var indexLastCaculated = 0
    
    public required init?(delegate: CollectionViewFlowLayoutDelegate?, collectionView: UICollectionView?) {
        guard let delegate = delegate else { return nil }
        self.collectionView = collectionView
        self.delegate = delegate
    }
    
    public func prepare() {}
    
    public func reload() {
        initValues()
        generateCells()
    }
    
    public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributedsCached[safe: indexPath.row]
    }
    
    public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return prepareSection(at: 0,  newRectScaning: rect).compactMap { attributedsCached[safe: $0.row] }
    }
    
    public func heightContentSize() -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        if attributedsCached.isEmpty { return 0 }
        let padding = collectionView.contentInset
        return (attributedsCached.last?.frame.maxY ?? 0) + padding.top + padding.bottom
    }
    
    public func widthContentSize() -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let padding = collectionView.contentInset
        return collectionView.frame.width - (padding.left + padding.right)
    }
    
    func initValues() {
        attributedsCached = []
        scaningRect = CGRect(origin: .init(x: -(collectionView?.frame.width ?? 0),
                                           y: -(collectionView?.frame.height ?? 0)),
                             size: .init(width: 3 * (collectionView?.frame.width ?? 0),
                                         height: 3 * (collectionView?.frame.height ?? 0)))
        indexOfMaxY = 0
        indexOfMinY = 0
        indexLastCaculated = 0
    }
    
    public func prepareCell(at sectionIndex: Int,
                            rowIndex: Int) -> UICollectionViewLayoutAttributes {
        UICollectionViewLayoutAttributes.init()
    }
    
    public func sizeForCell(at indexPath: IndexPath) -> CGSize? {
        .zero
    }
    
    public func widthContent() -> CGFloat {
        0.0
    }
    
    public func zoom(at indexPath: IndexPath, scaleX sx: CGFloat, y sy: CGFloat) {
        if let framePriviousCache = attributedsCached[safe: indexPath.row] {
            framePriviousCache.transform = framePriviousCache.transform.scaledBy(x: sx, y: sy)
        }
    }
    
    public func move(at indexPath: IndexPath, pointX px: CGFloat, pointY py: CGFloat) {
        if let framePriviousCache = attributedsCached[safe: indexPath.row] {
            framePriviousCache.transform = framePriviousCache.transform.translatedBy(x: px, y: py)
        }
    }
    
    public func tranform(at indexPath: IndexPath, callBack: (UICollectionViewLayoutAttributes) -> Void) {
        if let framePriviousCache = attributedsCached[safe: indexPath.row] {
            callBack(framePriviousCache)
        }
    }
    
    public func identity(at indexPath: IndexPath) {
        if let framePriviousCache = attributedsCached[safe: indexPath.row] {
            framePriviousCache.transform = .identity
        }
    }
    
    public func contentSize(at indexPath: IndexPath) -> CGSize? {
        if let framePriviousCache = attributedsCached[safe: indexPath.row] {
            return framePriviousCache.size
        }
        return nil
    }
}

private extension CollectionViewFlowLayoutAttributedManager {
    func generateCells() {
        guard let collectionView = collectionView else { return }
        let sectionIndex = 0
        let numberOfItems = collectionView.numberOfItems(inSection: sectionIndex)
        var maxY = scaningRect.minY

        if attributedsCached.isEmpty {
            for index in 0..<numberOfItems {
                let cellAtIndex = prepareCell(at: sectionIndex,
                                          rowIndex: index)
                maxY = max(maxY, cellAtIndex.frame.maxY)
                attributedsCached.append(cellAtIndex)
                if maxY >= scaningRect.maxY {
                    break
                }
                indexLastCaculated = index
                indexOfMaxY = index
            }
        }
    }
    
    private func prepareSection(at sectionIndex: Int, newRectScaning: CGRect) -> [IndexPath] {
        guard let collectionView = collectionView else { return [] }
        let numberOfItems = collectionView.numberOfItems(inSection: sectionIndex)
        var listIndexsInRectTermperator: [IndexPath] = []
        let direction: Direction = scaningRect.maxY > newRectScaning.maxY ? .top : .bottom
        self.scaningRect = newRectScaning
        var minY = scaningRect.maxY
        var maxY = scaningRect.minY
        var updated = false
        
        switch direction {
        case .top:
            for index in (0...indexOfMaxY).reversed() {
                let indexPath = IndexPath(row: index, section: sectionIndex)
                let cellAtIndex: UICollectionViewLayoutAttributes
                
                cellAtIndex = prepareCell(at: sectionIndex,
                                          rowIndex: index)
                if let attributedsCachedLast = attributedsCached.last,
                   indexPath.row > attributedsCachedLast.indexPath.row {
                    attributedsCached.append(cellAtIndex)
                }
                
                if !listIndexsInRectTermperator.contains(indexPath) {
                    listIndexsInRectTermperator.append(indexPath)
                }
                minY = min(minY, cellAtIndex.frame.minY)
                if cellAtIndex.frame.minY < scaningRect.maxY {
                    if !updated {
                        updated = true
                        if cellAtIndex.frame.minY < scaningRect.minY {
                            break
                        }
                    } else {
                        if cellAtIndex.frame.minY < scaningRect.minY {
                            break
                        } else {
                            indexOfMinY = index
                        }
                    }
                } else {
                    indexOfMaxY = index
                }
            }
            
        case .bottom:
            for index in indexOfMinY..<numberOfItems {
                let indexPath = IndexPath(row: index, section: sectionIndex)
                let cellAtIndex: UICollectionViewLayoutAttributes
                cellAtIndex = prepareCell(at: sectionIndex,
                                          rowIndex: index)
                if let attributedsCachedLast = attributedsCached.last,
                   indexPath.row > attributedsCachedLast.indexPath.row {
                    attributedsCached.append(cellAtIndex)
                }
                
                if !listIndexsInRectTermperator.contains(indexPath) {
                    listIndexsInRectTermperator.append(indexPath)
                }
                
                maxY = max(maxY, cellAtIndex.frame.maxY)
                if cellAtIndex.frame.maxY > scaningRect.minY {
                    if !updated {
                        updated = true
                        if cellAtIndex.frame.maxY > scaningRect.maxY {
                            break
                        }
                    } else {
                        if cellAtIndex.frame.maxY > scaningRect.maxY {
                            break
                        } else {
                            indexOfMaxY = index
                        }
                    }
                } else {
                    indexOfMinY = index
                }
            }
        case .none:
            print("nothing")
        }

        return listIndexsInRectTermperator
    }
}

