//
//  CollectionViewVerticalFlowLayoutAttributedManager.swift
//  Commons
//
//  Created by NguyenHao on 29/10/2023.
//

import UIKit

open class CollectionViewVerticalFlowLayoutAttributedManager: CollectionViewFlowLayoutAttributedManager {
    public override func prepareCell(at sectionIndex: Int,
                             rowIndex: Int) -> UICollectionViewLayoutAttributes {
        guard let delegate = delegate else { return .init() }
        if let framePriviousCache = attributedsCached[safe: rowIndex] {
            return framePriviousCache
        }
        else {
            let numberColumnInCollection = delegate.numberColumnInCollection()
            let indexColumnCurrent = rowIndex % numberColumnInCollection
            let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
            let sizeOfCell = sizeForCell(at: indexPath)
            let marginHorical: CGFloat = indexColumnCurrent == 0 ? 0 : (CGFloat(rowIndex % numberColumnInCollection) * delegate.marginHorizontal())
            let marginVertical: CGFloat = CGFloat((rowIndex) / numberColumnInCollection) == 0 ? 0 : CGFloat((rowIndex) / numberColumnInCollection) * delegate.marginVertical()
            let frameCaculator: CGRect
            
            let locationY: CGFloat = CGFloat((rowIndex) / numberColumnInCollection) * (sizeOfCell?.height ?? 0) + marginVertical
            let locationX: CGFloat = CGFloat(rowIndex % numberColumnInCollection) * (sizeOfCell?.width ?? 0) + marginHorical
            frameCaculator = .init(x: locationX,
                                   y: locationY,
                                   width: sizeOfCell?.width ?? 0,
                                   height: sizeOfCell?.height ?? 0)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath, frame: frameCaculator)
            return attributes
        }
    }
    
    public override  func sizeForCell(at indexPath: IndexPath) -> CGSize? {
        guard let numberColumnInCollection = delegate?.numberColumnInCollection() else { return nil }
        if numberColumnInCollection < 0 {
            return nil
        }
        let widthContent = widthContent()
        let width = numberColumnInCollection == 0 ? 0 : (widthContent / CGFloat(numberColumnInCollection))
        let height = delegate?.heightForCell(at: indexPath, widthCellOfContent: width)
        return .init(width: width, height: height ?? 0)
    }
    
    public override  func widthContent() -> CGFloat {
        guard let collectionView = collectionView,
              let delegate = delegate else { return 0.0 }
        let numberCellInCollection = delegate.numberColumnInCollection()
        let contentInset = collectionView.contentInset
        let paddingHorizontal = contentInset.left + contentInset.right
        let marginHorizontal = delegate.marginHorizontal()
        let widthOfCollectionView = collectionView.frame.width
        let marginHorizontalFinal = marginHorizontal * CGFloat(numberCellInCollection - 1)
        
        let widthContent = widthOfCollectionView - marginHorizontalFinal - paddingHorizontal
        return widthContent
    }
}
