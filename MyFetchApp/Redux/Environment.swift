//
//  Environment.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation
import Fuzi

/// 副作用处理
final class Environment {
    
    func loadDyttData() async -> AppAction {
        let html = await DyttRequest.loadMainHtml()
        let categoryModelArray = analyzingDyttData(html)
        return .updateDyttMainPage(dataArray: categoryModelArray)
    }
    
    func analyzingDyttData(_ html: String) -> [DyttCategoryModel] {
        print("开始解析-------")
        var resultArray: [DyttCategoryModel] = []
        do {
            let doc = try HTMLDocument(string: html, encoding: .utf8)
            if let elementById = doc.firstChild(css: "#menu") {
                let aTags = elementById.xpath("//div/ul/li/a").filter({ aTag in
                    aTag.stringValue != "经典影片"
                }).prefix(13).map { aTag in
                    DyttCategoryModel(aTag.stringValue, aTag["href"] ?? "")
                }
                resultArray.append(contentsOf: aTags)
//                for aTag in aTags {
//                    print(aTag.rawXML)
//                    print("\(aTag.stringValue) + \(aTag["href"]!)" )
//                }
            }
        } catch let error {
            print("解析失败：\(error.localizedDescription)")
        }
        return resultArray
    }
}

