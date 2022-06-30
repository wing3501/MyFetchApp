//
//  HttpHelper.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//
//https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#using-alamofire
//https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md

import Foundation
import Alamofire

struct HttpHelper {
    static var timeoutInterval: TimeInterval = 5
    
//    static func GET(_ url: URLConvertible, parameters: Parameters? = nil) async -> String? {
//        try? await AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .methodDependent))
//         .serializingString().value
        
        
//    }
    
    static func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders?) async -> String? {
        
//        MultipathServiceType 是一个枚举类型，它实际上是定义了一系列 Multipath 场景下使用网络的配置。所谓 Multipath 指的是用户同时有多条网络通道 （一般来说是移动网络和 WIFI 共存）的情况下，App 可以采用不同的策略来利用这些网络通道。 handover 枚举配置的含义是启用 Multipath, 但当且仅当主通道无法使用时，才会使用其他的通道。启用 handover 并且确保它正常工作，可以使我们的应用获得无缝切换的效果。
//        let configuration = URLSessionConfiguration.default
//        configuration.multipathServiceType = .handover
        
        //参数编码
//        ParameterEncoder
//                JSONParameterEncoder (.default,.prettyPrinted,.sortedKeys)
//                URLEncodedFormParameterEncoder
        //请求头设置的两种方式
//        let headers: HTTPHeaders = [
//            "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
//            "Accept": "application/json"
//        ]
//        let headers: HTTPHeaders = [
//            .authorization(username: "Username", password: "Password"),
//            .accept("application/json")
//        ]
        
//        AF.request("https://httpbin.org/get").response { response in
//            debugPrint(response)
//        }
        
        try? await AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil) { request in
            //需要设置更多的参数
            request.timeoutInterval = timeoutInterval
        }
        .serializingString().value
        
//       try? await AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: {
//            //需要设置更多的参数
//            $0.timeoutInterval = timeoutInterval
//        })
//        .serializingString().value
    }
}
