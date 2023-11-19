//
//  ScaleCellDismissController.swift
//  Commons
//
//  Created by NguyenHao on 05/11/2023.
//

import UIKit

public protocol ScaleCellDismissAnimatedTransitioningDelegate {
    
}

open class ScaleCellDismissController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var animator: ScaleCellUserInteractionDismiss?

    public init(animator: ScaleCellUserInteractionDismiss?) {
        self.animator = animator
        super.init()
    }
    
    deinit {
        print("deinit ScaleCellDismissController")
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("animateTransition")
    }
        
//    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromVC = transitionContext.viewController(forKey: .from),
//              let toVC = transitionContext.viewController(forKey: .to) else { return }
////        let snapShot = delegate.snapShotView()
//        let containerView = transitionContext.containerView
//        let finalFrame = transitionContext.finalFrame(for: toVC)
//        
//        print("containerView \(containerView.subviews)")
//        
////        containerView.addSubview(toVC.view)
////
////        toVC.view.isHidden = true
////        containerView.addSubview(snapShot)
//        
//
//        
////        containerView.addSubview(snapShot)
////        if let viewController = fromVC as? ScaleCellDismissAnimatedTransitioningDelegate {
////            viewController.animate(target: self) {
////
////            } animationCallBack: {
////
////            } completionCallBack: {
////
////            }
////        }
////        var snapShotView: UIView?
////        beginCallBack = { snapshotView in
////            snapShotView = snapshotView
////            containerView.addSubview(snapshotView)
////
////        }
////
////        endCallBack = {
////            snapShotView?.removeFromSuperview()
////        }
//        
//        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    }
    
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return animator ?? .init()
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        print("transitionCompleted")
    }
}
