//
//  HomeDataTool.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class HomeDataTool: NSObject {
    
    // 把请求和解析放在一起
    // 回调: 当前不立即调用, 先保存下来等到合适(就是看下,什么时候,可以获取到block,内部需要的值)的时候,再调用
    static func requestHomeDataList(page: Int = 1, result: @escaping ([ProductModel]) -> ()) {
        
        // 传递过来的page参数容错处理
        if page <= 0 {
            return
        }
        
        // 发送请求
        HttpTool.loadRequest(kRequestURL(page), method: .get) {  (responseObj: [String : Any], error: Error?) in
            
            // 1.判断是否有错误
            if error != nil {
                return
            }
            
            // 2.取出 goods_list 字典数组
            guard let dictArray = responseObj["goods_list"] as? [[String: Any]] else {
                return
            }
            
            // 3.定义模型并拼接成数组
            var models = [ProductModel]()
            models.append(contentsOf: dictArray.map { ProductModel(dict: $0) })
//            models.append(dictArray.map {ProductModel(dict: $0)})
//            for dict in dictArray {
//                let p = ProductModel(dict)
//                models.append(p)
//            }
            
            // 4.返回数组
            result(models)
        }

    }
}
