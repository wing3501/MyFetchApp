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
    
    static let example = Switch520Game(id: "134", title: "这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题", imageUrl: "https://picsum.photos/id/237/200/300", category: ["switch游戏","中文","更新"], datetime: "2022-08-10 10:45:03", downloadAdress: "")
}
