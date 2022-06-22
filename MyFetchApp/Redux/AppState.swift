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
    var dytt = DyttState()
    var ms = MovieSearchState()
}

extension AppState {
    struct DyttState {
        let host = "https://www.ygdy8.com"
        let mainPage = "https://www.ygdy8.com/index.html"
        var categoryData: [DyttCategoryModel] = []
    }
    struct MovieSearchState {
        var isRequestLoading = false
        var isButtonDisabled = true
        var websites: [MovieSearchWebSite] = []
    }
}
