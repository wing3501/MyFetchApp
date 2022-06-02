//
//  AppState.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import Combine

/// 状态管理
struct AppState {
    var name: String = ""
    var age:Int = 10
    var dytt = DyttState()
}

extension AppState {
    struct DyttState {
        let host = "https://www.ygdy8.com"
        var categoryData: [DyttCategoryModel] = []
    }
}
