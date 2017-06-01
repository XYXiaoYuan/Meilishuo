//
//  DismissAnimation.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/13.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class DismissAnimation: NSObject {

}

extension DismissAnimation: UIViewControllerAnimatedTransitioning {
    /// 动画的执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }

    /// 动画的执行过程
    /// 动画执行完后必须调用 transitionContext的一个完成方法,不然不会执行成功
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /*
         实现思路:
         1.获取到fromVC->fromView(UICollectionView)的当前的cell的ImageView
         2.将获取到的ImageView添加到window上
         3.获取当前cell的indexPath(当前indexPath就是主界面的那个cell的indexPath)
         4.将主界面的CollectionView传给fromVC
         5.通过主界面的CollectionView和indexPath来找到对应的cell(有可能找不到(在当前界面如果看不到则会返回nil))
         6.将cell的frame转换到window上
         7.执行ImageView的动画,让它的frame设置为cell的frame
         */

        // 1.获取到fromVC
        guard let fromVC = transitionContext.viewController(forKey: .from) as? DetailVC else {
            return
        }

        // 2.获取当前图片浏览器显示的cell
        guard let fromVisibleCell = fromVC.collectionView?.visibleCells.first as? DetailCell else {
            return
        }

        // 3.获取keywindow
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }

        // 4.获取当前cell的indexPath
        guard let fromIndexPath = fromVC.collectionView?.indexPath(for: fromVisibleCell) else {
            return
        }

        // 初始化imageView的frame
        var frame = CGRect()
        // 获取主界面的可见的最后一个cell
        var indexPathsForVisibleItems = fromVC.homeCollectionView!.indexPathsForVisibleItems
        indexPathsForVisibleItems = indexPathsForVisibleItems.sorted(by: { (indexPath1, indexPath2) -> Bool in
            return indexPath1 < indexPath2
        })

        // 获取主界面的可见的最后一个cell的indexPath
        let lastHomeIndexPath = indexPathsForVisibleItems.last ?? IndexPath()
        // 判断主界面的indexPath与当前from的indexPath的大小
        if lastHomeIndexPath < fromIndexPath {
            frame.origin.y = UIScreen.main.bounds.height
        }

        // 5.通过当前cell的IndexPath,和主界面的collectionView来获取那个位置的cell
        if let homeCell = fromVC.homeCollectionView?.cellForItem(at: fromIndexPath) {
            // 6.将cell的frame转换到window上
            frame = homeCell.convert(homeCell.bounds, to: keyWindow)
        }

        // 7.从cell中获得图片
        let imageView = fromVisibleCell.imageView

        // 8.将图片添加到windows上
        keyWindow.addSubview(imageView)

        // 9.执行动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            // 改变imageView的frame
            imageView.frame = frame
        }) { (_) in
            imageView.removeFromSuperview()
        }
        // 告诉系统动画执行完了
        transitionContext.completeTransition(true)
    }
}
