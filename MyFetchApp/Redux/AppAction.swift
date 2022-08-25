//
//  AppAction.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import UIKit
import SwiftUI

enum AppAction {
    case empty
    case loadDyttCategories
    case updateDyttCategories(dataArray: [DyttCategoryModel])
    case loadDyttCategoryPage(category: DyttCategoryModel)
    case updateDyttCategoryPage(category: DyttCategoryModel,items: [DyttItemModel],pageHrefs: [(Int,String)])
    case dyttCategoryPageLoadMore(category: DyttCategoryModel)
    case updateDyttCategoryPageLoadMore(category: DyttCategoryModel,items: [DyttItemModel],pageHrefs: [(Int,String)])
    case loadSearchSource
    case updateSearchSource(websites: [MovieSearchWebSite])
    case updateWebsite(website: MovieSearchWebSite,index: Int)
    case searchMovie(searchText: String)
    case dissmissLoading
    case detectMagnet(image: UIImage)
    case detectMagnetFrom(text: String)
    case updateMagnetLinks(links: [String])
    case updatePasteboardText(content: String)
    case updateToastMessage(message: String)
    case updateWifiString(wifiString: String)
    case resetQrSetting
    case createQrCode(qrCodeString: String)
    case updateQrCodeImage(image: UIImage)
    case cleanQrCenterImage
    case saveToAlbum(image: UIImage)
    case fetchSwitch520TotalPage(needFetch: Bool)
    case updateSwitch520TotalPage(needFetch: Bool,total: Int)
    case fetchGameEnd(games: [Switch520Game])
    case fetchGamePage(page: Int)
    case fetchGamePageEnd(page: Int,games: [Switch520Game])
    case saveGames
    case loadGames
    case loadGamesEnd(games: [Switch520Game])
    case loadGameInCoreData
    case loadGameInCoreDataEnd(games: [Game])
    case showTopCoverView(coverView: AnyView?)
    case closeTopCoverView
}

