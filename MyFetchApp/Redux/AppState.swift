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
    
    /// 子View隐藏tabbar
    var hideTabView = false
    
    /// 通用提示信息
    var toastMessage: String?
    /// 通用Loading
    var toastLoadingMessage = "Loading..."
    var toastLoading = false
    
    var dytt = DyttState()
    var movieSearch = MovieSearchState()
    var magnetState = MagnetState()
}

extension AppState {
    struct DyttState {
        let host = "https://www.ygdy8.com"
        let mainPage = "https://www.ygdy8.com/index.html"
        var categoryData: [DyttCategoryModel] = []
    }
    struct MovieSearchState {
        var isButtonDisabled = true
        var requestFinishedCount: Int?
        var websites: [MovieSearchWebSite] = []
    }
    struct MagnetState {
        var magnetLinks: [String] = []
    }
}
