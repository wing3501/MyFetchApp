//
//  Environment.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//
// https://www.jianshu.com/p/6a0dbb4e246a
import Foundation
import Fuzi

/// 副作用处理
final class Environment {
    
    func loadDyttCategories(_ mainPageUrl: String) async -> AppAction {
        let html = await WebviewDataFetchManager.shared.dataString(with: mainPageUrl)
        let categoryModelArray = analyzingDyttCategories(html)
        return .updateDyttCategories(dataArray: categoryModelArray)
    }
    
    func analyzingDyttCategories(_ html: String) -> [DyttCategoryModel] {
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
    
    func loadDyttCategoryPage(_ host: String,_ href: String) async -> AppAction {
        let url = href.hasPrefix("/") ? (host + href) : (host + "/" + href)
        let html = await WebviewDataFetchManager.shared.dataString(with: url)
        let (hrefs,items) = analyzingDyttItems(html)
        return .empty
    }
    
    func analyzingDyttItems(_ html: String) -> ([String],[DyttItemModel]) {
        var hrefs: [String] = []
        var items: [DyttItemModel] = []
        do {
            let doc = try HTMLDocument(string: html, encoding: .utf8)
            let tables = doc.xpath("//div[@class='co_content8']//table")
            for table in tables {
                let trs = table.xpath("//tbody/tr")
                if trs.count > 3 {
                    let titleTr = trs[1]
                    let subTitleTr = trs[2]
                    let descTr = trs[3]
                    
                    var title = ""
                    var href = ""
                    let titleAtag = titleTr.xpath("//a")
                    if !titleAtag.isEmpty {
                        let aTag = titleAtag[0]
                        title = aTag.stringValue
                        href = aTag["href"] ?? ""
                    }
                    
                    
                }
            }
            

        } catch let error {
            print("解析失败：\(error.localizedDescription)")
        }
        return (hrefs,items)
    }
}

extension NodeSet {
    func atag() -> (String,String) {
        if let first = self.first {
            return first.atag()
        }
        return ("","")
    }
}

extension XMLElement {
    func atag() -> (String,String) {
        if let tag = self.tag,tag == "a" {
            return (self.stringValue,self["href"] ?? "")
        }
        return ("","")
    }
}
