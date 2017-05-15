//
//  PresentAnimation.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/13.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class PresentAnimation: NSObject {
    /// imageView用于做放大动画
    fileprivate lazy var imageView =  UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    /// 获取主界面的图片,将图片放到imageView里面
    var infoTuple: (currentImage: UIImage?, superView: UIView)? {
        didSet {
            guard let currentImage = infoTuple?.currentImage, let supView = infoTuple?.superView else {
                return
            }
            
            // 给imageView赋值图片
            imageView.image = currentImage
            // 将supView的位置转换到window上
            imageView.frame = supView.convert(supView.bounds, to: nil)
        }
    }
}

extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    /// 动画的执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    /// 动画的执行过程
    /// 动画执行完后必须调用 transitionContext的一个完成方法,不然不会执行成功
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /*
         思路:
         1. 创建一个UIImageView
         2. 获取主界面点击的图片
         3. 获取主界面点击的那个cell的尺寸,并将尺寸的位置转换到window上
         4. 设置UIImageView的图片以及转换到的最新位置
         5. 将UIImageView添加到containerView
         6. 使用UIView的动画,将UIImageView的frame放大到指定的大小(整个屏幕)
         7. 动画执行完毕之后,移除UIImageView,添加toView(图片浏览器控制器的View)
         8. 动画执行完调用成功方法
         */
        
        // 将UIImageView添加到containerView
        let containerView = transitionContext.containerView
        containerView.addSubview(imageView)
        
        // 使用UIView的动画,将UIImageView的frame放大到指定的大小(整个屏幕)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: { 
            // 设置imageView的大小为全屏
            self.imageView.frame = UIScreen.main.bounds
        }) { (_) in
            self.imageView.removeFromSuperview()
            let toView = transitionContext.view(forKey: .to) ?? UIView()
            containerView.addSubview(toView)
            // 告诉系统动画执行完了
            transitionContext.completeTransition(true)
        }
    }
}
