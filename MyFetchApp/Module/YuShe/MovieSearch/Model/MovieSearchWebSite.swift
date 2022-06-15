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
    let baseUrl: String
    let searchUrl: String
    let resultXpath: MovieResultXpath? = nil
    var searchResult: [MovieResult] = []
    
    init() {
        name = ""
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

struct MovieResult {
    let title: String
    let href: String
    let image: String
}
