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
    let method: String
    let data: String
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
        data = ""
        method = ""
    }
}

struct MovieResultXpath: HandyJSON {
    let xpath = ""
    let title: HtmlTag? = nil
    let href: HtmlTag? = nil
    let image: HtmlTag? = nil
    let other: [HtmlTag]? = nil
}

struct HtmlTag: HandyJSON {
    let xpath = ""
    let key = ""
}

struct MovieResult: Identifiable {
    let title: String
    let href: String
    let image: String
    let other: [String]
    
    var id: String {
        title + href
    }
    
    static let example = MovieResult(title: "这是名字这是名字这是名字", href: "", image: "https://4k-m.com/upimg/01/20220614204346.jpg", other: ["豆瓣评分:5.9", "IMDB评分:4.0", "4K超清"])
}
