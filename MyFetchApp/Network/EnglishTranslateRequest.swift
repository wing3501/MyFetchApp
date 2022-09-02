//
//  TranslateWordRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/31.
//

import Foundation
import Alamofire
import SwiftSoup

struct EnglishTranslateRequest {
    
    /// 翻译单词短语用必应
    /// - Parameter content: 待翻译的英文
    /// - Returns: <#description#>
    static public func bingWebTranslate(_ content: String) async -> String? {
        // https://www.bing.com/dict/search?q=go+to
        var url = "https://www.bing.com/dict/search?q="
        url = url + content.split(separator: " ").reduce("") { partialResult, next in
            partialResult + (partialResult.isEmpty ? "" : "+") + next
        }
        let html = try? await AF.request(url).serializingString(encoding: .utf8).value
        if let html {
            parse(html: html)
        }
        return html
    }
    
    static public func parse(html: String) {
        let doc = try? SwiftSoup.parse(html)
        let lf_area = try? doc?.select("div.lf_area") //左侧容器
        let qdef = try? lf_area?.select("div.qdef") // 上部分翻译内容
        let se_div = try? lf_area?.select("div.se_div") // 下部分例句
        
        let hd_area = try? qdef?.select("div.hd_area") // 单词+音频
        let hd_p1_1 = try? hd_area?.select("div.hd_p1_1") //音频部分容器
        
        // 音标  ["美 [ˈæp(ə)l]", "英 [\'æpl]"]
        let primtxts = try? hd_p1_1?.select("div.b_primtxt").compactMap({ e in
            try? e.text()
        })
        
        // 音频地址
        let mp3s = try? hd_p1_1?.select("a.bigaud").compactMap({ element in
            try? element.attr("onmouseover")
        }).compactMap({ str in
            str.subString(with: "https://.+\\.mp3").first //提取音频地址   //https://dictionary.blob.core.chinacloudapi.cn/media/audio/george/04/e2/04E234717A67CA7810FE0F554EDB6816.mp3
        })
        
        // 翻译内容
        let ul = try? hd_area?.first()?.nextElementSibling()
        let pos_regtxt = ul?.children().compactMap({ element in
            if let pos = try? element.select("span.pos").first?.text(), // 标签
               let regtxt = try? element.select("span.b_regtxt").first?.child(0).text() { //翻译内容
                return (pos,regtxt)
            }
            return nil
        })
        
        // 复数、第三人称单数、现在分词、过去式等等
        let hd_div1 = try? qdef?.select("div.hd_div1").first()
        let hd_if = try? hd_div1?.child(0).text()  //第三人称单数：goes to  现在分词：going to  过去式：went to  过去分词：gone to
        
    }
    
    /// 翻译句子用免费的百度翻译API
    /// - Parameter content: 待翻译的英文
    /// - Returns: 译文
    static public func baiduTranslate(_ content: String) async -> String? {
        // https://api.fanyi.baidu.com/product/113
        let salt = String.random(count: 10)
        let param: Parameters = ["q":content, //请求翻译query
                                 "from":"en", //翻译源语言
                                 "to":"zh",   //翻译目标语言
                                 "appid": BaiduFanyi.appid,
                                 "salt": salt, //可为字母或数字的字符串
                                 "sign": (BaiduFanyi.appid + content + salt + BaiduFanyi.secretKey).md5     //appid+q+salt+密钥的MD5值
        ]
        
        let headers: HTTPHeaders = [
            .contentType("application/x-www-form-urlencoded")
        ]
        guard let response = try? await AF.request("https://fanyi-api.baidu.com/api/trans/vip/translate", method: .post, parameters: param,headers: headers)
//            .serializingString(encoding: .utf8).value else { return nil }
            
            .serializingDecodable(TranslateResponse.self).value else { return nil }
        return response.trans_result.first?.dst
    }
}
