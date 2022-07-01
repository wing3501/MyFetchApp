//
//  DyttItemModel.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/2.
//

import Foundation
import HandyJSON

struct DyttItemModel: HandyJSON,Identifiable {
    
    let title: String
    let subTitle: String
    let desc: String
    let href: String
    
    var id: String {
        title
    }
    
    init() {
        self.title = ""
        self.subTitle = ""
        self.desc = ""
        self.href = ""
    }
    
    init(title: String,subTitle:String,desc: String,href: String) {
        self.title = title
        self.subTitle = subTitle
        self.desc = desc
        self.href = href
    }
}
