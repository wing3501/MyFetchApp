//
//  DyttRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation
import Alamofire

struct DyttRequest {
    static func loadMainPage(_ mainPage: String) async -> String {
        do {
            let data = try await AF.request(mainPage).serializingData().value
            guard let result = String(data: data, encoding: .gbk) else { return "" }
            return result
        }catch {
            print(error)
        }
        return ""
    }
}
