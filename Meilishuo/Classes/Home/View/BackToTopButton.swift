//
//  BackToTopView.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/17.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class BackToTopButton: UIButton {

    var scrollView: UIScrollView = UIScrollView()

    lazy var backTopButton: UIButton = {
        $0.frame = CGRect(x: kScreenW - 60 * kScreenWScale, y: kScreenH * 0.85, width: 40, height: 40)
        $0.setImage(UIImage(named: "back_top_button"), for: UIControlState())
        $0.addTarget(self, action: #selector(backTopButtonClick(_:)), for: UIControlEvents.touchUpInside)
        return $0
    }(UIButton())

    override func willMove(toSuperview newSuperview: UIView?) {

        super.willMove(toSuperview: newSuperview)

        if (newSuperview?.isKind(of: UIScrollView.self))! {
            scrollView = newSuperview as! UIScrollView

            // 用KVO来监听父控件的滚动
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }

    deinit {
        scrollView .removeObserver(self, forKeyPath: "contentOffset")
    }

}

// MARK: - 私有方法
extension BackToTopButton {

    // 返回顶部按钮事件
    func backTopButtonClick(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        let isShow: Bool = scrollView.contentOffset.y > scrollView.frame.size.height * 0.5
        backTopButton.isHidden = !isShow
    }
}
