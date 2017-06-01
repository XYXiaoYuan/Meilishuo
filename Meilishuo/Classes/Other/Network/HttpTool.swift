//
//  HttpTool.swift
//  BeautyStory
//
//  Created by hikki on 2017/3/2.
//  Copyright © 2017年 hikki. All rights reserved.
//

import UIKit
import Alamofire

/// 请求方法
///
/// - options: options description
/// - get: get description
/// - head: head description
/// - post: post description
/// - put: put description
/// - patch: patch description
/// - delete: delete description
/// - trace: trace description
/// - connect: connect description
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
    static func loadRequest(_ urlString: String, method: HTTPToolMethod, callBack: @escaping ([String : Any], Error?) -> Void) {
        guard let method = HTTPMethod(rawValue: method.rawValue) else {
            return
        }

        Alamofire.request(urlString, method: method).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let value):
                callBack((value as? [String : Any]) ?? [:], nil)
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

        // responseJSON方法的参数说明:
        /// Adds a handler to be called once the request has finished.
        ///
        /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
        /// - parameter completionHandler: A closure to be executed once the request has finished.
        ///
        /// - returns: The request.
        // 给该请求过程完成时增加一个回调(待请求过程完成时执行闭包): 这个闭包在请求完成后在主线程中执行该闭包
        request.responseJSON(completionHandler: { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        })
        // 上一条语句的完整写法
//        request.responseJSON(queue: nil, options: .allowFragments) { (response: DataResponse<Any>) in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
