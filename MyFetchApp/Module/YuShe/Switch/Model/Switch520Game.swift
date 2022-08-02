//
//  Switch520Game.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/2.
//

import Foundation
import HandyJSON

struct Switch520Game :HandyJSON,Identifiable,Hashable{
    var id: String = ""
    var title: String = ""
    var imageUrl: String = ""
    var category: [String] = []
    var datetime: String = ""
    var downloadAdress: String = ""
}
