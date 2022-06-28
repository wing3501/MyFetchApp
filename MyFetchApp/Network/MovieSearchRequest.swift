//
//  MovieSearchRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/13.
//

import Foundation
import Alamofire

struct MovieSearchRequest {
    static func searchMovie(_ searchUrl: String,method: HTTPMethod,parameters: String?,encode: String? = "gb2312") async -> String {
        do {
            let data: Data
            if method == .post {
                data = try await AF.upload(multipartFormData: { multipartFormData in
                    if let params = paramPair(parameters) {
                        for (key,value) in params {
                            if let encode = encode,encode == "utf8" {
                                multipartFormData.append(value.utf8Data, withName: key)
                            }else {
                                multipartFormData.append(value.gb2312, withName: key)
                            }
                        }
                    }
                }, to: searchUrl,interceptor: nil,requestModifier: { request in
                    request.timeoutInterval = 10;
                }).serializingData().value
                
            }else {
                let params = paramPair(parameters)
                data = try await AF.request(searchUrl,method: method,parameters: params).serializingData().value
            }
            
            if let resultString = String(data: data, encoding: .utf8){
                return resultString
            }else if let resultString = String(data: data, encoding: .gb2312) {
                return resultString
            }
        } catch {
            print("searchMovie error: \(error)")
        }
        return ""
    }
    
    static func paramPair(_ paramString: String?) -> [String: String]? {
        guard let parameters = paramString else { return nil }
        var params: [String: String] = [:]
        let paramPairs = parameters.split(separator: "&")
        for pair in paramPairs {
            let arr = pair.split(separator: "=")
            params[String(arr.first ?? "")] = String(arr.second ?? "")
        }
        return params
    }
}
