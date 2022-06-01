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
        analyzingDyttData(html)
        return .updateDyttMainPage(data: html)
    }
    
    func analyzingDyttData(_ html: String) {
        print("开始解析-------")
        do {
            let doc = try HTMLDocument(string: html, encoding: .utf8)
            if let elementById = doc.firstChild(css: "#menu") {
                let lis = elementById.xpath("//div/ul/li/a")
                for li in lis {
                    print(li.rawXML)
                    print("\(li.stringValue) + \(li["href"])" )
                }
                
//
//                for aTag in aTags {
//                    print(aTag.rawXML)
//                }
            }
            
            
//            <div id="menu"><div class="contain"><ul>
//                        <li>
//    <a href="/html/gndy/dyzz/index.html">最新影片</a></li><li>
            
        } catch let error {
            print("解析失败：\(error.localizedDescription)")
        }
    }
}

