//
//  PanDismissInteractiveTransition.swift
//  Commons
//
//  Created by NguyenHao on 05/11/2023.
//

import UIKit

public class ScaleCellUserInteractionDismiss: UIViewPropertyAnimator {
    public var transitionContext: UIViewControllerContextTransitioning?
    
    deinit {
        print("deinit ScaleCellUserInteractionDismiss")
    }
}

public protocol PanGestureDismissDelegate: AnyObject {
    func began(at location: CGPoint)
    func changed(_ location: CGPoint)
    func cancelled()
    func ended()
}

extension PanGestureDismissDelegate {
    func began(at location: CGPoint) {}
    func changed(_ location: CGPoint) {}
    func cancelled() {}
    func ended() {}
}

public protocol DismissIneractiveFromViewControllerInput: AnyObject, PanGestureDismissDelegate {
    func panDismissInView() -> UIView
    func snapShot() -> UIView
}

open class PanDismissInteractiveTransition: UIPercentDrivenInteractiveTransition {
    public let animator = ScaleCellUserInteractionDismiss()
    
    public var interactionInProgress = false
    public var shouldCompleteTransition = false
    
    private weak var fromViewControllerInput: DismissIneractiveFromViewControllerInput?
    
    public init(fromViewControllerInput: DismissIneractiveFromViewControllerInput?) {
        self.fromViewControllerInput = fromViewControllerInput
        super.init()
        guard let viewControllerInput = fromViewControllerInput else { return }
        prepareGestureRecognizer(in: viewControllerInput.panDismissInView())
    }
    
    deinit {
        print("deinit PanDismissInteractiveTransition")
    }
    
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        self.animator.transitionContext = transitionContext
        self.animator.addAnimations { [weak self] in
            guard  let self = self,
                   let fromVC = transitionContext.viewController(forKey: .from),
                   let toVC = transitionContext.viewController(forKey: .to),
                   let snapShot = self.fromViewControllerInput?.snapShot() else { return }
            
            let containerView = transitionContext.containerView
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVC.view)
            containerView.addSubview(snapShot)
        }
    }
    
    open override func finish() {
        super.finish()
        guard let fromVC = animator.transitionContext?.viewController(forKey: .from),
              let toVC = animator.transitionContext?.viewController(forKey: .to) else {
            self.animator.transitionContext = nil
            return
        }
        fromVC.view.removeFromSuperview()
        toVC.view.isHidden = false
        animator.transitionContext?.containerView.removeFromSuperview()
        animator.transitionContext?.completeTransition(!(animator.transitionContext?.transitionWasCancelled ?? false))
        self.animator.transitionContext = nil
    }
    
    open override func cancel() {
        super.cancel()
        guard let fromVC = animator.transitionContext?.viewController(forKey: .from),
              let toVC = animator.transitionContext?.viewController(forKey: .to) else {
            self.animator.transitionContext = nil
            return
        }
        toVC.view.removeFromSuperview()
        fromVC.view.isHidden = false
        animator.transitionContext?.completeTransition(false)
        self.animator.transitionContext = nil
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let viewControllerInput = fromViewControllerInput else { return }
        
        let state = gestureRecognizer.state
        let location = gestureRecognizer.location(in: viewControllerInput.panDismissInView())
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch state {
        case .began:
            interactionInProgress = true
            viewControllerInput.began(at: location)
        case .changed:
            viewControllerInput.changed(location)
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            viewControllerInput.cancelled()
            cancel()
        case .ended:
            viewControllerInput.ended()
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
