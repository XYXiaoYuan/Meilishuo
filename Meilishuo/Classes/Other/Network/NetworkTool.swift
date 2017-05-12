//
//  NetworkTool.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType {
    case get
    case post
}

class NetworkTool: NSObject {
    static func request(type: RequestType, url: String, param: [String: Any],resultBlock: @escaping (Any?,Error?)->()) {
        
        // 成功的block
        let successBlock = {
            (task: URLSessionDataTask, responseObj: Any?) -> Void in
            resultBlock(responseObj, nil)
        }
        
        // 失败的block
        let failBlock = {
            (task: URLSessionDataTask?, error: Error) -> Void in
            resultBlock(nil, error)
        }
        
        // AFN请求管理者
        let manager = AFHTTPSessionManager()
        
        // get请求
        if type == .get {
            
            manager.get(url, parameters: param, progress: nil, success: successBlock, failure:failBlock)
            
        } else {
            
            manager.post(url, parameters: param, progress: nil, success: successBlock, failure:failBlock)
            
        }
        
        
    }
}
