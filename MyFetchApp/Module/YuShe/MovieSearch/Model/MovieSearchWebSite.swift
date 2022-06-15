//
//  MovieSearchWebSite.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/10.
//

import Foundation
import HandyJSON

struct MovieSearchWebSite: HandyJSON,Identifiable {
    let name: String
    let icon: String
    let baseUrl: String
    let searchUrl: String
    let resultXpath: MovieResultXpath? = nil
    var searchResult: [MovieResult] = []
    
    var id: String {
        name + baseUrl
    }
    
    init() {
        name = ""
        icon = ""
        baseUrl = ""
        searchUrl = ""
    }
}

struct MovieResultXpath: HandyJSON {
    let xpath = ""
    let title: HtmlTag? = nil
    let href: HtmlTag? = nil
    let image: HtmlTag? = nil
}

struct HtmlTag: HandyJSON {
    let xpath = ""
    let key = ""
}

struct MovieResult: Identifiable {
    let title: String
    let href: String
    let image: String
    
    var id: String {
        title + href
    }
}
