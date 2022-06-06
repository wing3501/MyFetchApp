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
    var dataArray: [DyttItemModel] = []
    var leftHrefs: [String] = []
    
    required init() {
        title = ""
        href = ""
    }
    
    init(_ title: String,_ href: String) {
        self.title = title
        self.href = href
    }
}

