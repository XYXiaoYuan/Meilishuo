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
        
        // 请求参数
        let param = [
            "opt_type" : 1,
            "size" : 20,
            "offset" : (page - 1) * 20]
        
        // 发送请求
        NetworkTool.request(type: .get, url: kRequestURL, param: param) { (responseObj: Any?, error: Error?) in
            
            // 1.判断是否有错误
            if error != nil {
                return
            }
            
            // 2.1.取出响应体中的字典
            guard let resultObj = responseObj as? [String: Any] else {
                return
            }
            
            // 2.2.取出 goods_list 字典数组
            guard let dictArray = resultObj["goods_list"] as? [[String: Any]] else {
                return
            }
            
            // 3.定义模型并拼接成数组
            var models = [ProductModel]()
            for dict in dictArray {
                let p = ProductModel(dict)
                models.append(p)
            }
            
            // 4.返回数组
            result(models)
            
        }
    }
}
