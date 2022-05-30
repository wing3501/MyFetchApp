//
//  DyttRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation
import Alamofire

struct DyttRequest {
    static let mainPage = "https://www.ygdy8.com/index.html"
    static func loadMainPage() async -> String {
        do {
            let data = try await AF.request(mainPage).serializingData().value
            guard let result = String(data: data, encoding: .gbk) else { return "" }
            return result
        }catch {
            print(error)
        }
        return ""
    }
    
    static func loadMainHtml() async -> String {
        await withCheckedContinuation({ checkedContinuation in
            WebviewDataFetchManager.shared.dataString(with: mainPage) { string in
                checkedContinuation.resume(returning: string)
            }
        })
    }
}
