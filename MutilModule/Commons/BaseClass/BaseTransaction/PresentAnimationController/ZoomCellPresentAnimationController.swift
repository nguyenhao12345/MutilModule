//
//  ZoomCellPresentAnimationController.swift
//  Commons
//
//  Created by NguyenHao on 31/10/2023.
//

import UIKit

public protocol ZoomCellViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var timeDuration: TimeInterval { get }
    var indexPath: IndexPath { get }
}

open class ZoomCellPresentAnimationController: NSObject, ViewControllerAnimatedTransitioning, ZoomCellViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    public var snapShot: ZoomAble?
    public var timeDuration: TimeInterval
    public var indexPath: IndexPath
    
    public init(originFrame: CGRect,
                at indexPath: IndexPath,
                timeDuration: TimeInterval,
                snapShot: ZoomAble?) {
        self.originFrame = originFrame
        self.timeDuration = timeDuration
        self.indexPath = indexPath
        self.snapShot = snapShot
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        toVC.view.frame = originFrame
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear
        
        toVC.view.isHidden = true
        containerView.addSubview(toVC.view)
        if let snapShot = snapShot {
            containerView.addSubview(snapShot)
            snapShot.actionZoom(duration: timeDuration) {
                
            } completion: { [weak self] _ in
                toVC.view.isHidden = false
                self?.snapShot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
