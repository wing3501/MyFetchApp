//
//  MovieSearchRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/13.
//

import Foundation
import Alamofire

struct MovieSearchRequest {
    static func searchMovie(_ searchUrl: String,method: HTTPMethod,parameters: String?) async -> String {
        do {
            let data: Data
            if method == .post {
                data = try await AF.upload(multipartFormData: { multipartFormData in
                    let params = paramPair(parameters)
                    for (key,value) in params {
                        multipartFormData.append(value.gb2312, withName: key)
                    }
                }, to: searchUrl).serializingData().value
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
    
    static func paramPair(_ paramString: String?) -> [String: String] {
        guard let parameters = paramString else { return [:] }
        var params: [String: String] = [:]
        let paramPairs = parameters.split(separator: "&")
        for pair in paramPairs {
            let arr = pair.split(separator: "=")
            params[String(arr.first ?? "")] = String(arr.second ?? "")
        }
        return params
    }
}
