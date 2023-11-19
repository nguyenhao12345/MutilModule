//
//  HomePresenter.swift
//  MutilModule
//
//  Created by NguyenHao on 18/11/2023.
//

import UIKit
import Commons
import Photos

protocol HomePresenterProtocol: AnyObject {
    func requestThumnails()
    func numberThumnailsInSection() -> Int
    func thumnail(at indexPath: IndexPath,
                  widthContent: CGFloat) -> UIImage?
    func thumnailsIsEmpty() -> Bool
    
    func asset(at indexPath: IndexPath) -> PHAsset?
}

final class HomePresenterImplement: BasePresenter {
    weak var view: HomeViewControllerProtocol?
    private let assetsLocalDataHandler = AssetsLocalDataHandler()
    private var assetResult: PHFetchResult<PHAsset>?

}

extension HomePresenterImplement: HomePresenterProtocol {
    func requestThumnails() {
        let folderName = "TEST"
        assetsLocalDataHandler.getImages(from: folderName) { result in
            self.assetResult = result
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.view?.fetchingAssetsOnSuccess()
            }
        }
    }
    
    func numberThumnailsInSection() -> Int {
        return assetResult?.count ?? 0
    }
    
    func thumnail(at indexPath: IndexPath,
                  widthContent: CGFloat) -> UIImage? {
        assetResult?.object(at: indexPath.row).toImage(targetHeight: widthContent)
    }
    
    func thumnailsIsEmpty() -> Bool {
        (assetResult?.count ?? 0) == 0
    }
    
    func asset(at indexPath: IndexPath) -> PHAsset? {
        assetResult?.object(at: indexPath.row)
    }
}
