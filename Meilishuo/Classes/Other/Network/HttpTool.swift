//
//  HttpTool.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit
import Alamofire

/// 请求方法
public enum HTTPToolMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class HttpTool: NSObject {

    static func loadRequest(_ urlString: String, method: HTTPToolMethod, callBack: @escaping ([String: Any], Error?) -> Void) {
        guard let method = HTTPMethod(rawValue: method.rawValue) else {
            return
        }

        Alamofire.request(urlString, method: method).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let value):
                callBack((value as? [String: Any]) ?? [ : ], nil)
            case .failure(let error):
                callBack([:], error)
            }
        }
    }
}

// MARK: - 为便于理解,写出的完整形式的请求方法的实现
extension HTTPToolMethod {

    static func loadRequest2(_ urlString: String, method: HTTPToolMethod) {
        // 根据HTTPToolMethod参数,来初始化HTTPMethod对象
        guard let method = HTTPMethod(rawValue: method.rawValue) else {
            return
        }

        // 根据url发送请求,返回一个请求对象
        let request: DataRequest = Alamofire.request(urlString, method: method)

        // 给该请求过程完成时增加一个回调(待请求过程完成时执行闭包): 这个闭包在请求完成后在主线程中执行该闭包
        request.responseJSON(completionHandler: { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        })
    }
}
