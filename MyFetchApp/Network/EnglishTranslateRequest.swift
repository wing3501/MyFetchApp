//
//  TranslateWordRequest.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/31.
//

import Foundation
import Alamofire

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
        return try? await AF.request(url).serializingString(encoding: .utf8).value
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
