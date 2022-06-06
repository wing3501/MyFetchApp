//
//  AppAction.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation

enum AppAction {
    case empty
    case loadDyttCategories
    case updateDyttCategories(dataArray: [DyttCategoryModel])
    case loadDyttCategoryPage(category: DyttCategoryModel)
    case updateDyttCategoryPage(category: DyttCategoryModel,items: [DyttItemModel],leftPageHrefs: [(Int,String)])
}

