//
//  HomeAnimation.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/10.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

fileprivate let duration : Double = 1.0

// MARK:-弹出动画代理
protocol HomeAnimationPresentDelegate: NSObjectProtocol {
    func presentAnimationView() -> UIView
    func presentAnimationFromFrame() -> CGRect
    func presentAnimationToFrame() -> CGRect
    
}

// MARK:-消失动画代理
protocol HomeAnimationDismissDelegate: NSObjectProtocol {
    func dismissAnimationView() -> UIView
    func dismissAnimationFromFrame() -> CGRect
    func dismissAnimationToFrame() -> CGRect
    
}

// MARK:-HomeAnimation实现UIViewControllerTransitioningDelegate协议
class HomeAnimation: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK:-对内属性
    // 是否是弹出
    var isPresent: Bool = true
    
    weak var presentDelegate: HomeAnimationPresentDelegate?
    weak var dismissDelegate: HomeAnimationDismissDelegate?
    
    // 弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    // 消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }

}

// MARK:-HomeAnimation实现UIViewControllerAnimatedTransitioning协议
extension HomeAnimation: UIViewControllerAnimatedTransitioning {
    
    // 转场动画,需要的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 具体怎么做动画
    // Context:上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 区分是弹出还是消失
        if isPresent {
            presentAnimation(transitionContext)
        } else {
            dismissAnimation(transitionContext)
        }
    }
}

// MARK:-自定义present,dismiss动画
extension HomeAnimation {
    
    // 自定义弹出动画
    fileprivate func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning)  {
        guard let presentDelegate = presentDelegate else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        // 1.做动画的视图
        let animationView = presentDelegate.presentAnimationView()
        
        // 2.动画的起始位置
        let fromFrame = presentDelegate.presentAnimationFromFrame()
        
        // 3.动画的结束位置
        let toFrame = presentDelegate.presentAnimationToFrame()
        
        containerView.addSubview(animationView)
        animationView.frame = fromFrame
        
        // 如果是自定义转场动画,目标控制器的视图,不会再自动添加到 containerView 里面去了
        let detailView = transitionContext.view(forKey: .to)
        detailView?.frame = kScreenBounds
        containerView.addSubview(detailView!)
        detailView?.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            
            animationView.frame = toFrame
            detailView?.alpha = 1.0
            
        }) { (complete) in
            animationView.removeFromSuperview()
            // 动画过程中,不允许与用户交互,我们在动画结束后,手动告诉它,结束了,可以进行用户交互了
            transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    fileprivate func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissDelegate = dismissDelegate else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        // 1.做动画的视图
        let animationView = dismissDelegate.dismissAnimationView()
        
        // 2.动画的起始位置
        let fromFrame = dismissDelegate.dismissAnimationFromFrame()
        
        // 3.动画的结束位置
        let toFrame = dismissDelegate.dismissAnimationToFrame()
        
        containerView.addSubview(animationView)
        animationView.frame = fromFrame
        
        // 如果是自定义转场动画,目标控制器的视图,不会再自动添加到 containerView 里面去了
        let fromView = transitionContext.view(forKey: .from)
        
        UIView.animate(withDuration: duration, animations: {
            
            animationView.frame = toFrame
            fromView?.alpha = 0.0
            
        }) { (complete) in
            fromView?.removeFromSuperview()
            animationView.removeFromSuperview()
            // 动画过程中,不允许与用户交互,我们在动画结束后,手动告诉它,结束了,可以进行用户交互了
            transitionContext.completeTransition(true)
        }
    }
    
}
