//
//  MovieSearchWebSite.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/10.
//

import Foundation
import HandyJSON

struct MovieSearchWebSite: HandyJSON {
    let name: String
    let searchUrl: String
    var searchText: String {
        return name
    }
    
    init() {
        name = ""
        searchUrl = ""
    }
}
