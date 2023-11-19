//
//  ViewController.swift
//  MutilModule
//
//  Created by NguyenHao on 22/10/2023.
//

import UIKit
import Commons

protocol HomeViewControllerProtocol: AnyObject {
    func fetchingAssetsOnSuccess()
}

final class HomeViewController: BaseViewController, PhotoPermission {
    @IBOutlet private(set) weak var permissionButton: BaseButton!
    @IBOutlet private(set) weak var albumCollectionView: BaseCollectionView!
    
    var presenter: HomePresenterProtocol?
    private var snapShotView: ImageSnapShot? = nil
    private lazy var alumnCollectionViewLayout: CollectionViewFlowLayout = {
        let layout = CollectionViewFlowLayout(delegate: self,
                                              collectionView: albumCollectionView,
                                              flowLayoutStyle: .vertical)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (presenter?.thumnailsIsEmpty() ?? true) == false { return }
        checkAuthorization { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if !(status == .authorized || status == .restricted) {
                    self.requestOpenSetting(title: "Title", message: "Go to Settings?")
                    self.permissionButton.isHidden = false
                    self.albumCollectionView.isHidden = true
                } else {
                    self.permissionButton.isHidden = true
                    self.presenter?.requestThumnails()
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.albumCollectionView.reloadData()
        }
    }
}

private extension HomeViewController {
    func setupViews() {
        view.backgroundColor = .black
        setupPhotoPermissionButton()
        setupAlbumCollectionView()
    }
    
    func setupPhotoPermissionButton() {
        permissionButton.touchUpInsideCallback = { [weak self] in
            guard let self = self else { return }
            self.requestOpenSetting(title: "Title", message: "Go to Settings?")
        }
    }
    
    func setupAlbumCollectionView() {
        albumCollectionView.backgroundColor = .white
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        albumCollectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        albumCollectionView.collectionViewLayout = alumnCollectionViewLayout
        albumCollectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberThumnailsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let thumbnail = presenter?.thumnail(at: indexPath,
                                            widthContent: (alumnCollectionViewLayout.contentSize(at: indexPath) ?? .zero).width)
        cell.setImage(thumbnail)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageAtIndexPath = presenter?.thumnail(at: indexPath, widthContent: UIScreen.main.bounds.width) else { return }
        let frameOfCollectionViewCell = albumCollectionView.frameOfCollectionViewCell(at: indexPath) ?? .init()
        snapShotView = ImageSnapShot(image: imageAtIndexPath, frameCell: frameOfCollectionViewCell, targetWidth: UIScreen.main.bounds.width)
        
        guard let asset = presenter?.asset(at: indexPath) else { return }
        let albumnDetailViewController = AlbumDetailViewController.init(asset: asset, indexPath: indexPath)
        albumnDetailViewController.transitioningDelegate = self
        albumnDetailViewController.modalPresentationStyle = .fullScreen
        albumnDetailViewController.transitioningDelegate = self
        present(albumnDetailViewController, animated: true)
    }
}

extension HomeViewController: CollectionViewFlowLayoutDelegate {
    func marginHorizontal() -> CGFloat {
        4
    }
    
    func marginVertical() -> CGFloat {
        4
    }
    
    func numberColumnInCollection() -> Int {
        UIDevice.current.orientation.isLandscape ? 5 : 3
    }
    
    func heightForCell(at indexPath: IndexPath, widthCellOfContent: CGFloat) -> CGFloat {
        return 100
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let viewController = presented as? AlbumDetailViewController {
            return ZoomCellPresentAnimationController(originFrame: view.bounds,
                                                      at: viewController.indexPath,
                                                      timeDuration: 0.5,
                                                      snapShot: snapShotView)
        }
        return nil
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func fetchingAssetsOnSuccess() {
        albumCollectionView.reloadData()
    }
}
