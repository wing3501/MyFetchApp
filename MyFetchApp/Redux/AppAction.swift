//
//  AppAction.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import UIKit

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
    case updateMagnetLinks(links: [String])
    case updatePasteboardText(content: String)
    case updateToastMessage(message: String)
    case updateWifiString(wifiString: String)
    case resetQrSetting
    case createQrCode(qrCodeString: String)
    case updateQrCodeImage(image: UIImage)
}

