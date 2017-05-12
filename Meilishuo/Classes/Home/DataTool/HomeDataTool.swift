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
            
            if error == nil {
                
                var models = [ProductModel]()
                
                guard let resultObj = responseObj as? [String: Any] else {
                    return
                }
                
                guard let dictArray = resultObj["goods_list"] as? [[String: Any]] else {
                    return
                }
                
                for dict in dictArray {
                    let p = ProductModel(dict)
                    models.append(p)
                }
                
                // 最合适调用block的位置(传值的位置)
                result(models)
            } else {
                print(error ?? "")
            }
            
        }
    }
}
