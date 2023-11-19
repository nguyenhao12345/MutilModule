//
//  AlbumDetailViewController.swift
//  MutilModule
//
//  Created by NguyenHao on 30/10/2023.
//

import UIKit
import Commons
import Photos

final class AlbumDetailViewController: BaseViewController {
    @IBOutlet private(set) weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var priviousSwipeAt: CGPoint?

    var asset: PHAsset
    var indexPath: IndexPath

    private var scaleCellDismissInteractiveTransition: PanDismissInteractiveTransition?
    
    private var scaleDisssController: ScaleCellDismissController?
    private var imageDetailSnapShot: ImageDetailSnapShot?
        
    init(asset: PHAsset, indexPath: IndexPath) {
        self.asset = asset
        self.indexPath = indexPath
        super.init(nibName: "AlbumDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = asset.toImage(targetWidth: UIScreen.main.bounds.width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scaleCellDismissInteractiveTransition = .init(fromViewControllerInput: self)
        scaleDisssController = .init(animator: scaleCellDismissInteractiveTransition?.animator)
        transitioningDelegate = self
    }
}

extension AlbumDetailViewController {
    func instance(with asset: PHAsset, indexPath: IndexPath) -> AlbumDetailViewController {
        return AlbumDetailViewController(asset: asset, indexPath: indexPath)
    }
}

extension AlbumDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scaleDisssController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return scaleCellDismissInteractiveTransition
    }
}

extension AlbumDetailViewController: DismissIneractiveFromViewControllerInput {
    func panDismissInView() -> UIView {
        view
    }
    
    func snapShot() -> UIView {
        imageDetailSnapShot ?? UIView()
    }
    
    func began(at location: CGPoint) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.imageDetailSnapShot?.removeFromSuperview()
            self.imageView.isHidden = false
        }
        imageView.isHidden = true
        priviousSwipeAt = location

        let originY = UIScreen.main.bounds.height / 2 - ((imageView.image?.size.height ?? 0) / 2)
        let origin = CGPoint(x: 0, y: originY)
        let size = imageView.image?.size ?? .zero
        let frame = CGRect(origin: origin, size: size)
        let snapShot = ImageDetailSnapShot(image: imageView.image ?? UIImage(), frame: frame)
        self.imageDetailSnapShot = snapShot
    }
    
    func changed(_ location: CGPoint) {
        guard let priviousSwipeAt = priviousSwipeAt else { return }
        let delta = location - priviousSwipeAt
        imageDetailSnapShot?.move(pointX: delta.x, pointY: delta.y)
        self.priviousSwipeAt = location
    }
    
    func cancelled() {
    
    }
    
    func ended() {
        
    }
}

