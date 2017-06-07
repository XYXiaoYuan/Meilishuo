//
//  DetailVC.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/10.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

fileprivate let cellID = "detail"

class DetailVC: UICollectionViewController {

    // MARK: - 对外属性
    // 1.从首页传递过来的模型数据
    var dtDataSource: [ProductModel] = [ProductModel]() {
        didSet {
            collectionView?.reloadData()
        }
    }

    // 2.主界面的collectionView
    var homeCollectionView: UICollectionView!

    // 3.主界面传递过来的 thumb_url 下载好的对应的图片
    lazy var currentImage: UIImage = UIImage()

    // 功能: 用于在DetailVC界面触发更新Home界面刷新操作,然后在Home界面刷新完毕后更新DetailVC界面的数据源,从而触发该界面刷新数据
    // 参数: 参数是一个子闭包,该闭包保存"在闭包内部的代码执行完毕(即在Home界面刷新完毕后),更新DetailVC界面的数据源"的操作代码 (DetailClosureType)
    // 保存刷新Home界面更多数据操作的大闭包
    // DetailClosureType类型 是 "([ProductModel]) -> Void" 的别名
    fileprivate var loadHomeDataClosure: ((@escaping DetailClosureType) -> Void)?

    // 自定义构造函数,内部用PhotoBrowserLayout进行布局
    init(dtDataSource: [ProductModel], currentIndexPath: IndexPath, homeCollectionView: UICollectionView, currentImage: UIImage, loadHomeDataClosure: @escaping (@escaping DetailClosureType) -> Void) {
        super.init(collectionViewLayout: DetailFlowLayout())

        // 1.更新数据源,内部会同步刷新表格
        self.dtDataSource = dtDataSource
        // 2.跳转到指定的位置
        collectionView?.scrollToItem(at: currentIndexPath, at: .left, animated: false)
        // 3.保存刷新Home界面更多数据操作的大闭包
        self.loadHomeDataClosure = loadHomeDataClosure
        // 4.记录主界面的CollectionView
        self.homeCollectionView = homeCollectionView
        // 5.主界面传递过来的 thumb_url 下载好的对应的图片
        self.currentImage = currentImage

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.注册cell
        collectionView?.register(DetailCell.self, forCellWithReuseIdentifier: cellID)

        // 2.设置UI
        setupUI()
    }
}

// MARK: - 设置UI
extension DetailVC {

    fileprivate func setupUI() {
        createButton(title: "退出", isLeft: true, action: #selector(exitHandle))
        createButton(title: "保存", isLeft: false, action: #selector(saveHandle))
    }

    private func createButton(title: String, isLeft: Bool, action: Selector) {
        let width: CGFloat = 80
        let height: CGFloat = 40
        let margin: CGFloat = 20
        let x: CGFloat = isLeft ? margin : UIScreen.main.bounds.width - margin - width
        let y: CGFloat = UIScreen.main.bounds.height - margin - height

        let button = UIButton()
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.blue
        view.addSubview(button)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    @objc
    private func exitHandle() {
        dismiss(animated: true)
    }

    @objc
    private func saveHandle() {
        // 1.获取当前的cell
        guard let cell = collectionView?.visibleCells.first as? DetailCell else {
            return
        }

        // 2.获取当前cell中的图片
        let image = cell.currentImage

        // 3.将图片保存到相册中
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveSucceed), nil)
    }

    @objc
    private func saveSucceed(image: UIImage, error: Error?, contextInfo: Any?) {
        print("图片保存成功")
    }
}

// MARK: - UICollectionViewDataSource
extension DetailVC {

    // 返回每组有多少个item
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dtDataSource.count
    }

    // 负责创建cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DetailCell

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DetailVC {

    // 即将显示某一个cell的时候会调用这个时候
    // 负责给cell赋值的
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("详情\(indexPath.item)🌲")

        // 设置数据源
        let pCell = cell as! DetailCell
        guard let url = URL(string: dtDataSource[indexPath.item].hd_thumb_url) else {
            return
        }

        pCell.imageView .sd_setImage(with: url, placeholderImage: self.currentImage)

        // 当滑动到最后一个item的时候刷新调用首页的加载更多数据的接口,并传值过来
        if (indexPath.item == dtDataSource.count - 1) {

            loadHomeDataClosure?({ [weak self] (dataSource: [ProductModel]) in
                self?.dtDataSource = dataSource
            })
        }

    }
}
