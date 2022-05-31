//
//  Environment.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation


/// 副作用处理
final class Environment {
    
    func loadDyttData() async -> AppAction {
        let dataString = await DyttRequest.loadMainHtml()
        return .updateDyttMainPage(data: dataString)
    }
}
