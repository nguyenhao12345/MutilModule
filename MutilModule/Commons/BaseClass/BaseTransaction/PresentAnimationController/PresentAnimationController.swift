//
//  PresentAnimationController.swift
//  Commons
//
//  Created by NguyenHao on 30/10/2023.
//

import UIKit

public protocol ViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var timeDuration: TimeInterval { get }
}
 
public protocol PresentAnimatedTransitioning {
    func animate(presentAnimationController: ViewControllerAnimatedTransitioning,
                 beiginCallBack: VoidCallBack,
                 animationCallBack: VoidCallBack,
                 completionCallBack: @escaping VoidCallBack)
}

open class PresentAnimationController: NSObject, ViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    public var timeDuration: TimeInterval
    
    public init(originFrame: CGRect, timeDuration: TimeInterval) {
        self.originFrame = originFrame
        self.timeDuration = timeDuration
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        toVC.view.frame = originFrame
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        let containerView = transitionContext.containerView
        
        toVC.view.isHidden = true
        containerView.addSubview(toVC.view)
//        if let snapshot = snapshot {
//            snapshot.frame = originFrame
//            snapshot.layer.masksToBounds = true
//            containerView.addSubview(snapshot)
//        }

        if let viewController = fromVC as? PresentAnimatedTransitioning {
            viewController.animate(presentAnimationController: self) {
                
            } animationCallBack: {
                
            } completionCallBack: {
                toVC.view.isHidden = false
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
