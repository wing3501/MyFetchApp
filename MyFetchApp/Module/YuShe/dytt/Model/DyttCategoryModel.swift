//
//  DyttCategoryModel.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/1.
//

import Foundation
import HandyJSON

class DyttCategoryModel: HandyJSON {
    let title: String
    let href: String
    var currentPage: Int = 1
    var dataArray: [DyttItemModel] = []
    var pageHrefs: [(Int,String)] = []
    
    var footerRefreshing: Bool = false
    var noMore: Bool = false
    
    required init() {
        title = ""
        href = ""
    }
    
    init(_ title: String,_ href: String) {
        self.title = title
        self.href = href
    }
}

