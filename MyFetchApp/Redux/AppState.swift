//
//  AppState.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import Combine
import SwiftUI

/// 状态管理
struct AppState {
    
    /// 导航路径
    var navigationPath = NavigationPath()
    
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
    var myQrCode = MyQrCodeState()
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
    struct MyQrCodeState {
        var qrcodeString = ""
        var qrCodeImage: UIImage?
        var centerImage: UIImage?
        var checker = MyQrCodeChecker()
        
        class MyQrCodeChecker {
            static let wifiString = "WIFI:T:WPA;S:{wifiName};P:{wifiPassword};H:false;"
            @Published var wifiName = ""
            @Published var wifiPassword = ""
            
            var wifiStringChanged: AnyPublisher<String,Never> {
                $wifiName
                    .combineLatest($wifiPassword)
                    .flatMap { (name,password) in
                        var wifiContent = AppState.MyQrCodeState.MyQrCodeChecker.wifiString
                        wifiContent.replace("{wifiName}", with: name)
                        wifiContent.replace("{wifiPassword}", with: password)
                        return Just(wifiContent)
                    }
                    .eraseToAnyPublisher()
            }
        }
    }
}
