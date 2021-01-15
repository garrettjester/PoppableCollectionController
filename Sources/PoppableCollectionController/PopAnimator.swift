//
//  PopAnimator.swift
//  WRLDS
//
//  Created by Garrett Jester on 1/12/21.
//  Copyright © 2021 WRLDS. All rights reserved.
//

import UIKit

///----------------------
/// POP ANIMATOR
///----------------------
/// An animator object for presenting/dismissing UICollectionView cell items.

public class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let _operationType: UINavigationController.Operation
    private let _transitionDuration: TimeInterval
    

    
    public init(operation: UINavigationController.Operation) {
        _operationType = operation
        _transitionDuration = 0.4
    }
    
    public init(operation: UINavigationController.Operation, andDuration duration: TimeInterval) {
        _operationType = operation
        _transitionDuration = duration
    }
    
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        _transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if _operationType == .push {
            performPushTransition(transitionContext)
        } else if _operationType == .pop {
            performPopTransition(transitionContext)
        }
    }
    
    
    
    ///-------------------------------------
    /// PUSH TRANSITION (CELL -> FULLSCREEN)
    ///-------------------------------------
    /// Accesses and configures the necessary view components,
    /// then expands the cell to fullscreen mode.
    private func performPushTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. SETUP
        guard let toView = transitionContext.view(forKey: .to) else {
            print("Animator Error: The destination view is unreachable.")
            return
        }
        
        guard let fromVC = transitionContext.viewController(
                forKey: .from) as? PoppableCollectionController,
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = fromVC.collectionView,
              let currentCell = fromVC.sourceCell else {
            
            // The components required for the animation are unavailable,
            // but we can still complete the transition without it.
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        var topInset: CGFloat = 0.0
        
        
        if let toNavigationController = toVC.navigationController, !toNavigationController.isNavigationBarHidden {
            topInset = toNavigationController.navigationBar.frame.height
        }
        
        let container = transitionContext.containerView
        container.addSubview(toView)
        
        let screenshotToView = UIImageView(image: toView.screenshot)
        screenshotToView.frame = currentCell.frame
        screenshotToView.contentMode = .scaleAspectFill
        
        
        let containerOrigin = fromView.convert(screenshotToView.frame.origin, to: container)
        screenshotToView.frame.origin = containerOrigin
        
        var endFrame = screenshotToView.convert(screenshotToView.frame, to: toView)
        endFrame.origin.y = topInset + 20

        print("END FRAME \(endFrame)")
        
        // If a source image is specified, use it for the transition,
        // otherwise create a screenshot of the cell's content.
        let screenshotFromView = UIImageView(image: fromVC.sourceImage ?? currentCell.screenshot)
        screenshotFromView.frame = screenshotToView.frame
        
        container.addSubview(screenshotToView)
        container.addSubview(screenshotFromView)
        
        toView.isHidden = true
        screenshotToView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            screenshotToView.isHidden = false
        }
        
        // 2. ANIMATE
        UIView.animate(
            withDuration: _transitionDuration, delay: 0, usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0, options: [], animations: { () -> Void in
                screenshotFromView.alpha = 0.0
                screenshotToView.frame = endFrame
                screenshotFromView.frame = screenshotToView.frame
            }) { _ in
            screenshotToView.removeFromSuperview()
            screenshotFromView.removeFromSuperview()
            screenshotToView.backgroundColor = .black
            toView.alpha = 1.0
            toView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
    
    ///------------------------------------
    /// POP TRANSITION (FULLSCREEN -> CELL)
    ///------------------------------------
    /// Accesses and configures the necessary view components,
    /// then animates the controller back to the cell.
    private func performPopTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. SETUP
        guard let toView = transitionContext.view(forKey: .to) else {
            print("Animator Error: The destination view is unreachable.")
            return
        }
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? PoppableCollectionController,
              let toCollectionView = toViewController.collectionView,
              let fromViewController = transitionContext.viewController(forKey: .from),
              let fromView = fromViewController.view,
              let currentCell = toViewController.sourceCell else {
            
            // The components required for the animation are unavailable,
            // but we can still complete the transition without it.
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        let container = transitionContext.containerView
        
        container.addSubview(toView)
        
        let screenshotFromView = UIImageView(image: fromView.screenshot)
        screenshotFromView.frame = fromView.frame
        
        let screenshotToView = UIImageView(image: toViewController.sourceImage ?? currentCell.screenshot)
        screenshotToView.frame = screenshotFromView.frame
        
        container.addSubview(screenshotToView)
        
        container.insertSubview(screenshotFromView, belowSubview: screenshotToView)
        
        screenshotToView.alpha = 0.0
        fromView.isHidden = true
        currentCell.isHidden = true
        
        let containerOrigin = toCollectionView.convert(currentCell.frame.origin, to: container)
        
        // 2. ANIMATE
        UIView.animate(
            withDuration: _transitionDuration, delay: 0, usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0, options: [], animations: { () -> Void in
                screenshotToView.alpha = 1.0
                screenshotFromView.frame = currentCell.frame
                screenshotFromView.frame.origin = containerOrigin
                screenshotToView.frame = screenshotFromView.frame
                
            }) { _ in
            currentCell.isHidden = false
            screenshotFromView.removeFromSuperview()
            screenshotToView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
