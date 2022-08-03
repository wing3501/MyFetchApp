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
}
