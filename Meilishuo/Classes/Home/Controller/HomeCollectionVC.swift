//
//  HomeCollectionVC.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

fileprivate let cellID = "home"

class HomeCollectionVC: UICollectionViewController {
    
    // MARK:-对内属性
    // 1.当前页码
    fileprivate var currentPage: Int = 1
    // 2.详情页面控制器,用weak修饰它,避免循环引用
    fileprivate weak var detailVC = DetailVC()
    // 3.转场动画代理
    fileprivate lazy var animationDelegate: HomeAnimation = { [weak self] in
        $0.presentDelegate = self
        $0.dismissDelegate = self
        return $0
    }(HomeAnimation())
    // 4.首页的模型数据
    fileprivate var models : [ProductModel] = [ProductModel]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK:-生命周期入口
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.title = "美丽说瀑布流"
        
        // 加载数据
        loadData()
    }
}

// MARK:- 私有方法
extension HomeCollectionVC {
    
    fileprivate func loadData() {
        
        HomeDataTool.requestHomeDataList { [weak self] (models: [ProductModel]) in
            self?.models = models
        }
    }
    
    func loadMoreData() {
        
        currentPage += 1
        // 不管失败还是成功,页码,每次访问都会加一,中间可能会漏掉好多数据
        HomeDataTool.requestHomeDataList(page: currentPage) { [weak self] (models: [ProductModel]) in
            self?.models += models;
            
            if models.count == 0 {
                self?.currentPage -= 1
            }
        }
    }
}

// MARK:- 数据源
extension HomeCollectionVC {
    // 返回每组有多少个item
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    // 负责创建cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProductCell
        
        return cell
    }
    
    // 即将显示某一个cell的时候会调用这个时候
    // 负责给cell赋值的
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let pCell = cell as! ProductCell
        
        pCell.models = models[indexPath.row]
        
        print(indexPath.row)
        // 最后一个显示的时候,加载下一页
        if indexPath.row == models.count - 1 {
            loadMoreData()
        }
    }
    
    // 点击了cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailVC()
        self.detailVC = vc
        vc.models = models
        vc.scrollIndexPath = indexPath
        
        // 设置转场动画代理
        vc.transitioningDelegate = animationDelegate;
        
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK:-转动动画之present代理
extension HomeCollectionVC: HomeAnimationPresentDelegate {
    func presentAnimationView() -> UIView {
        guard let currentIndexPath = collectionView?.indexPathsForSelectedItems?.first else {
            return UIView()
        }
        
        let model = models[currentIndexPath.row]
        if let url = URL(string: model.hd_thumb_url) {
            let imageView = UIImageView()
            imageView.sd_setImage(with: url)
            return imageView
        }
        
        return UIView()

    }
    
    func presentAnimationFromFrame() -> CGRect {
        guard let currentIndexPath = collectionView?.indexPathsForSelectedItems?.first else {
            return CGRect.zero
        }
        
        guard let cell = collectionView?.cellForItem(at: currentIndexPath) else {
            return CGRect.zero
        }
        
        let window = UIApplication.shared.keyWindow!
        let resultFrame = collectionView?.convert(cell.frame, to: window) ?? CGRect.zero
        
        return resultFrame
    }
    
    func presentAnimationToFrame() -> CGRect {
        return kScreenBounds
    }
    
}

// MARK:-转动动画之dismiss代理
extension HomeCollectionVC: HomeAnimationDismissDelegate {
    func dismissAnimationView() -> UIView {
        let model = models[self.detailVC?.currentRow ?? 0]
        if let url = URL(string: model.hd_thumb_url) {
            let imageView = UIImageView()
            imageView.sd_setImage(with: url)
            return imageView
        }
        
        return UIView()
    }
    
    func dismissAnimationFromFrame() -> CGRect {
        return kScreenBounds
    }
    
    func dismissAnimationToFrame() -> CGRect {
        let currentRow = self.detailVC?.currentRow ?? 0
        let currentIndexPath = IndexPath(row: currentRow, section: 0)
        
        guard let cell = collectionView?.cellForItem(at: currentIndexPath) else {
            var currentVisibleIndexPath = collectionView?.indexPathsForVisibleItems
            
            // 注意,这个数组不是从小到大的顺序排列的
            // 排序
            currentVisibleIndexPath?.sort(by: { (first, second) -> Bool in
                return first.row < second.row
            })
            
            let minRow = currentVisibleIndexPath?.first?.row ?? 0            
            if currentIndexPath.row < minRow {
                return CGRect.zero
            } else {
                return kScreenRightDown
            }
            
        }
        
        let window = UIApplication.shared.keyWindow!
        let resultFrame = collectionView?.convert(cell.frame, to: window) ?? CGRect.zero
        
        return resultFrame
    }
    
}
