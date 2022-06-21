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
    
    /// 搜索词url编码后再特殊处理  悠悠mp4 使用
    let searchKeyReplace: ValueReplace?
    let movieUrl: String
    let method: String
    let data: String
    let dataEncode: String
    let resultPath: MovieResultPath? = nil
    var searchResult: [MovieResult] = []
    
    var id: String {
        name + baseUrl
    }
    
    init() {
        name = ""
        icon = ""
        baseUrl = ""
        searchUrl = ""
        searchKeyReplace = nil
        movieUrl = ""
        data = ""
        dataEncode = "gb2312"
        method = ""
    }
}

struct MovieResultPath: HandyJSON {
    let xpath = ""
    let jsonPath = ""
    let movieId: ContentPath? = nil
    let title: ContentPath? = nil
    let href: ContentPath? = nil
    let image: ContentPath? = nil
    let other: [ContentPath]? = nil
}

struct ContentPath: HandyJSON {
    let xpath = ""
    let key = ""
    
    let jsonPath = ""
    let valueReplace: ValueReplace? = nil
    let regex = ""
}

struct ValueReplace: HandyJSON {
    let org = ""
    let new = ""
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
