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

    // MARK: - 对内属性
    // 1.当前页码
    fileprivate var currentPage = 1
    // 2.1.弹出的动画模型
    fileprivate lazy var presentAnimation = PresentAnimation()
    // 2.2.退出的动画模型
    fileprivate lazy var dismissAnimation = DismissAnimation()
    // 3.首页的模型数据
    fileprivate var homeDataSource = [ProductModel]() {
        didSet {
            collectionView?.reloadData()
        }
    }

    // 4.回到顶部按钮
    fileprivate lazy var backTopButton: UIButton = {
        $0.frame = CGRect(x: kScreenW - 60 * kScreenWScale, y: kScreenH * 0.85, width: 40, height: 40)
        $0.setImage(UIImage(named: "back_top_button"), for: UIControlState())
        $0.addTarget(self, action: #selector(backTopButtonClick(_:)), for: UIControlEvents.touchUpInside)
        return $0
    }(UIButton())

   // MARK: - 生命周期入口
    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.title = "美丽说瀑布流"
        view.addSubview(backTopButton)
        backTopButton.isHidden = true

        // 加载数据
        loadData()
    }
}

// MARK: - 私有方法
extension HomeCollectionVC {

    // 返回顶部按钮事件
    func backTopButtonClick(_ sender: UIButton) {
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }

    fileprivate func loadData() {

        HomeDataTool.requestHomeDataList { [weak self] (models: [ProductModel]) in
            self?.homeDataSource = models
        }
    }

    func loadMoreData(updateDetailClosure: DetailClosureType? = nil) {

        let nextPage = currentPage + 1
        // 不管失败还是成功,页码,每次访问都会加一,中间可能会漏掉好多数据
        HomeDataTool.requestHomeDataList(page: nextPage) { [weak self] (models: [ProductModel]) in
            self?.currentPage = nextPage
            print("😃😃😃😃😃😃主界面加载第\(nextPage)页😃😃😃😃😃😃")

            guard let updateDetailClosure = updateDetailClosure else {
                self?.homeDataSource += models
                return
            }

            self?.homeDataSource += models

            guard let homeDataSource = self?.homeDataSource else {
                return
            }

            updateDetailClosure(homeDataSource)

        }

    }
}

// MARK: - UICollectionView数据源
extension HomeCollectionVC {

    // 返回每组有多少个item
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeDataSource.count
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

        pCell.productModels = homeDataSource[indexPath.item]

        print("首页\(indexPath.item)🍀")
        // 最后一个显示的时候,加载下一页
        if (indexPath.item == homeDataSource.count - 1) {
            loadMoreData()
        }
    }
}

// MARK: - UICollectionView代理
extension HomeCollectionVC {

    // 点击了cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCell
        guard let image = cell.imageView.image else {
            return
        }

        let detailVc = DetailVC(dtDataSource: homeDataSource, currentIndexPath: indexPath, homeCollectionView: collectionView, currentImage: image) { [weak self] (updateDetailClosure: @escaping DetailClosureType) in
            self?.loadMoreData(updateDetailClosure: updateDetailClosure)
        }

        // 设置转场动画代理
        detailVc.transitioningDelegate = self
        // 2.给转场动画的模型赋值
        presentAnimation.infoTuple = (image, cell)

        present(detailVc, animated: true, completion: nil)
    }
}

extension HomeCollectionVC: UIViewControllerTransitioningDelegate {

    /// 当控制器弹出另一个控制器的时候,会来到该方法
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }

    /// 当控制器dismiss掉之后会来到该方法
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }
}

extension HomeCollectionVC {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard let collectionView = collectionView else {
            return
        }

        let isShow: Bool = collectionView.contentOffset.y > view.frame.size.height * 0.5
        backTopButton.isHidden = !isShow
    }
}
