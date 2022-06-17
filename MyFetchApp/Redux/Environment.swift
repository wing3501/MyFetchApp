//
//  Environment.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//
//
import Foundation
import Fuzi

/// 副作用处理
final class Environment {
    
    func loadDyttCategories(_ mainPageUrl: String) async -> AppAction {
        let html = await WebviewDataFetchManager.shared.dataString(with: mainPageUrl)
        let categoryModelArray = analyzingDyttCategories(html)
        return .updateDyttCategories(dataArray: categoryModelArray)
    }
    
    func analyzingDyttCategories(_ html: String) -> [DyttCategoryModel] {
        var resultArray: [DyttCategoryModel] = []
        do {
            let doc = try HTMLDocument(string: html, encoding: .utf8)
            if let elementById = doc.firstChild(css: "#menu") {
                let aTags = elementById.xpath("//div/ul/li/a").filter({ aTag in
                    !["经典影片","高分经典","收藏本站","APP下载"].contains(aTag.stringValue)
                }).prefix(13).map { aTag in
                    DyttCategoryModel(aTag.stringValue, aTag["href"] ?? "")
                }
                resultArray.append(contentsOf: aTags)
            }
        } catch let error {
            print("解析失败：\(error.localizedDescription)")
        }
        return resultArray
    }
    
    func loadDyttCategoryPage(_ host: String,_ category: DyttCategoryModel) async -> AppAction {
        let href = category.href
        let url = href.hasPrefix("/") ? (host + href) : (host + "/" + href)
        let html = await WebviewDataFetchManager.shared.dataString(with: url)
        let (pageHrefs,items) = analyzingDyttItems(html)
        return .updateDyttCategoryPage(category: category, items: items, pageHrefs: [(1,href)] + pageHrefs)
    }
    
    func analyzingDyttItems(_ html: String) -> ([(Int,String)],[DyttItemModel]) {
        var pageHrefs: [(Int,String)] = []
        var items: [DyttItemModel] = []
        do {
            let doc = try HTMLDocument(string: html, encoding: .utf8)
            let tables = doc.xpath("//div[@class='co_content8']//table")
            for table in tables {
                let trs = table.xpath("./tbody/tr")
                if trs.count > 3 {
                    let titleTr = trs[1]
                    let subTitleTr = trs[2]
                    let descTr = trs[3]
                    
                    let titleAtags = titleTr.xpath(".//a")
                    let title = titleAtags[titleAtags.count > 1 ? 1 : 0].stringValue
                    let href = titleAtags[titleAtags.count > 1 ? 1 : 0]["href"]
                    
                    let subTitleFont = subTitleTr.xpath(".//font")
                    let subTitle = !subTitleFont.isEmpty ? subTitleFont.first!.stringValue : ""
                    
                    let descTd = descTr.xpath(".//td")
                    let desc = !descTd.isEmpty ? descTd.first!.stringValue : ""
                    
                    items.append(DyttItemModel(title: title, subTitle: subTitle, desc: desc, href: href ?? ""))
                }
            }
            //剩余的页
            let pageAtags = doc.xpath("//div[@class='co_content8']//div[@class='x']//a")
            for pageAtag in pageAtags {
                let title = pageAtag.stringValue
                let href = pageAtag["href"] ?? ""
                if title.hasPrefix("["),let page = Int(title[1...(title.count-2)]) {
                    pageHrefs.append((page, href))
                }
            }
            
        } catch let error {
            print("解析失败：\(error.localizedDescription)")
        }
        return (pageHrefs,items)
    }
    
    func dyttCategoryPageLoadMore(_ host: String,_ category: DyttCategoryModel) async -> AppAction {
//    https://www.ygdy8.com/html/gndy/china/index.html
//    https://www.ygdy8.com/html/gndy/china/list_4_2.html
        let indexHref = category.href
        let indexUrl = indexHref.hasPrefix("/") ? (host + indexHref) : (host + "/" + indexHref)
        let baseUrl = String(indexUrl[indexUrl.startIndex..<indexUrl.lastIndex(of: "/")!])
        let nextHref = category.pageHrefs[category.currentPage - 1].1//list_4_2.html
        let url = nextHref.hasPrefix("/") ? (baseUrl + nextHref) : (baseUrl + "/" + nextHref)
        print(url)
        let html = await WebviewDataFetchManager.shared.dataString(with: url)
        let (pageHrefs,items) = analyzingDyttItems(html)
        var needAddHrefs: [(Int, String)] = []
        if let last = category.pageHrefs.last,let newLast = pageHrefs.last,newLast.0 > last.0 {
            needAddHrefs = pageHrefs.filter({ $0.0 > last.0})
        }
        return .updateDyttCategoryPageLoadMore(category: category, items: items, pageHrefs: needAddHrefs)
    }
    
    func loadSearchSource() async -> AppAction {
        if let json = Bundle.main.string(from: "MovieSearchWebsites.json"),
           let dataArray = [MovieSearchWebSite].deserialize(from: json){
            let websites = dataArray.filter { website in
                website != nil
            }.map({ $0!})
            return .updateSearchSource(websites: websites)
        }
        return .empty
    }
    
    func searchMovie(_ searchText: String,from website: MovieSearchWebSite) async -> MovieSearchWebSite {
        guard !searchText.isEmpty else { return website }
        var result = ""
        if website.method == "post" {
            let paramString = website.data.replacingOccurrences(of: "{searchText}", with: searchText)
            result = await MovieSearchRequest.searchMovie(website.searchUrl, method: .post, parameters: paramString)
        }else {
            let url = website.searchUrl.replacingOccurrences(of: "{searchText}", with: searchText.URLEncode)
            result = await MovieSearchRequest.searchMovie(url, method: .get, parameters: nil)
        }
        
        if let doc = try? HTMLDocument(string: result, encoding: .utf8),
           let resultXpath = website.resultXpath,
           let titleTag = resultXpath.title,
           let hrefTag = resultXpath.href,
           let imageTag = resultXpath.image {
        
            var resultArray: [MovieResult] = []
            
            let arr = doc.xpath(resultXpath.xpath)
            for item in arr {
                var title = ""
                if let titleEle = item.xpath(titleTag.xpath).first {
                    title = titleEle.attr(titleTag.key)
                }
                var href = ""
                if let hrefEle = item.xpath(hrefTag.xpath).first {
                    href = hrefEle.attr(hrefTag.key)
                    if !href.hasPrefix("http") {
                        href = website.baseUrl + href
                    }
                }
                var image = ""
                if let imgEle = item.xpath(imageTag.xpath).first {
                    image = imgEle.attr(imageTag.key)
                    if !image.hasPrefix("http") {
                        image = website.baseUrl + image
                    }
                }
                var other: [String] = []
                if let otherXpaths = resultXpath.other,!otherXpaths.isEmpty {
                    for htmlTag in otherXpaths {
                        if let ele = item.xpath(htmlTag.xpath).first {
                            other.append(ele.attr(htmlTag.key))
                        }
                    }
                }
                
                resultArray.append(MovieResult(title: title, href: href, image: image,other: other))
            }
            var newWebsite = website
            newWebsite.searchResult = resultArray
            return newWebsite
        }
        return website
    }
}

extension XMLElement {
    func attr(_ key: String) -> String {
        return key.isEmpty ? self.stringValue : (self[key] ?? "")
    }
}
