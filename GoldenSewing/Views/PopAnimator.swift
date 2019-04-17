//
//  PopAnimator.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/17/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var presenting = true
    public var originFrame = CGRect.zero
    
    private let duration = 1.0
    private var dismissCompletion: (()->Void)?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let childView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : childView.frame
        let finalFrame = presenting ? childView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            childView.transform = scaleTransform
            childView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            childView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(childView)
        
        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0,
                       animations: {
                        childView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        childView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}

