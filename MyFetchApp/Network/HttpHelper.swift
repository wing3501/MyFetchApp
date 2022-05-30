//
//  HttpHelper.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import Alamofire

struct HttpHelper {
    static var timeoutInterval: TimeInterval = 5
    
    static func GET<Parameters: Encodable>(_ url: URLConvertible, parameters: Parameters?) async -> String? {
        try? await AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .methodDependent))
         .serializingString().value
    }
    
    static func request<Parameters: Encodable>(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) async -> String? {
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
        
       try? await AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: {
            //需要设置更多的参数
            $0.timeoutInterval = timeoutInterval
        })
        .serializingString().value
    }
}
