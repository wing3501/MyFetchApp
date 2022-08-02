//
//  Switch520Request.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/2.
//

import Foundation
import Alamofire

struct Switch520Request {
    
    static func loadHtml(_ url: String) async -> String? {
        try? await AF.request(url).serializingString(encoding: .utf8).value
    }
    
    static func requestDownloadUrl(_ id: String) async -> String? {
//        action=user_down_ajax&post_id=38617
        let param: Parameters = ["action":"user_down_ajax","post_id":id]
        let result = (try? await AF.request("https://switch520.com/wp-admin/admin-ajax.php", method: .post, parameters: param)
            .serializingString(encoding: .utf8).value)?.toDictionary
        return result?["msg"] as? String
    }
    
    static func loadPage(_ page: Int) async -> String {
        do {
            let data = try await AF.request("https://switch520.com/page/2").serializingData().value
            guard let result = String(data: data, encoding: .utf8) else { return "" }
            return result
        }catch {
            print(error)
        }
        return ""
    }
    
    static func requestDownloadUrl() async -> String {
//        action=user_down_ajax&post_id=38617
        let param: Parameters = ["action":"user_down_ajax","post_id":38617]
        
        let result = try? await AF.request("https://switch520.com/wp-admin/admin-ajax.php", method: .post, parameters: param)
            .serializingString(encoding: .utf8).value
        return result ?? ""
    }
    
    static func loadDownloadDetail() async -> String {
//        window.location='https://d.switch520.net/9490.html';setTimeout(function(){window.close()},5000)
        
        let result = try? await AF.request("https://switch520.com/go?post_id=38617").serializingString(encoding: .utf8).value
        return result ?? ""
    }
}
