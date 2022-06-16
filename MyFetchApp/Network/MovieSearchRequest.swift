//
//  MovieSearchRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/13.
//

import Foundation
import Alamofire

struct MovieSearchRequest {
    static func searchMovie(_ searchUrl: String,method: HTTPMethod,parameters: Parameters?) async -> String {
        
        do {
            let data = try await AF.request(searchUrl,method: method,parameters: parameters).serializingData().value
            if let resultString = String(data: data, encoding: .utf8){
                return resultString
            }
        } catch {
            print("searchMovie error: \(error)")
        }
        return ""
    }
}
