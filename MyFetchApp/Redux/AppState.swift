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
    var mainView = MainView()
}

extension AppState {
    struct MainView {
        enum Index: Hashable {
            case home,account
        }
        
        var selection: Index = .home
    }
}
