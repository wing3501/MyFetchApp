//
//  MovieSearchRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/13.
//

import Foundation
import Alamofire

struct MovieSearchRequest {
    static func searchMovie(_ searchUrl: String) async -> String {
        if let data = try? await AF.request(searchUrl).serializingData().value,
           let resultString = String(data: data, encoding: .utf8){
            return resultString
        }
        return ""
    }
}
