//
//  Environment.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//
//
import Foundation
import Fuzi
import UIKit
import SwiftSoup

/// 副作用处理
final class Environment {
    
}
// MARK: - 电影天堂业务

extension Environment {
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
}

// MARK: - 电影搜索业务
extension Environment {
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
            result = await MovieSearchRequest.searchMovie(website.searchUrl, method: .post, parameters: paramString,encode: website.dataEncode)
        }else {
            var searchKey = searchText.URLEncode
            if let replace = website.searchKeyReplace {
                searchKey = searchKey.replacingOccurrences(of: replace.org, with: replace.new)
            }
            let url = website.searchUrl.replacingOccurrences(of: "{searchText}", with: searchKey)
            result = await MovieSearchRequest.searchMovie(url, method: .get, parameters: nil)
        }
//        print("接口返回----\(result)")
        
        var resultArray: [MovieResult] = []
        if let jsonPath = website.resultPath?.jsonPath,!jsonPath.isEmpty {
            //把结果当做json解析
            resultArray = parseData(result, byJsonPath: website)
        }else {
            //把结果当做html进行解析
            resultArray = parseData(result, byXpath: website)
        }
        if !resultArray.isEmpty {
            var newWebsite = website
            newWebsite.searchResult = resultArray
            return newWebsite
        }
        return website
    }
    
    func parseData(_ result:String,byJsonPath website: MovieSearchWebSite) -> [MovieResult] {
        if let _ = website.resultPath?.jsonPath,
           let dic = result.toDictionary,
           let resultPath = website.resultPath {
        
            var resultArray: [MovieResult] = []
            if let array = dic[resultPath.jsonPath] as? Array<Dictionary<String,Any>>, !array.isEmpty {
                for item in array {
                    var title = ""
                    if let titleTag = resultPath.title,let val = item[titleTag.jsonPath] as? String {
                        title = val
                    }
                    
                    var href = ""
                    if !website.movieUrl.isEmpty,let movieIdTag = resultPath.movieId, let val = item[movieIdTag.jsonPath] {
                        href = website.movieUrl.replacingOccurrences(of: "{movieId}", with: "\(val)")
                    }else if let hrefTag = resultPath.href, let val = item[hrefTag.jsonPath] as? String {
                        href = val
                    }
                    
                    var image = ""
                    if let imageTag = resultPath.image,let val = item[imageTag.jsonPath] as? String {
                        image = val
                        if let valueReplace = imageTag.valueReplace {
                            image = image.replacingOccurrences(of: valueReplace.org, with: valueReplace.new)
                        }
                    }
//                    print("图片-----\(image)")
                    var other: [String] = []
                    if let otherPaths = resultPath.other,!otherPaths.isEmpty {
                        for tag in otherPaths {
                            other.append(item[tag.jsonPath] as? String ?? "")
                        }
                    }
                    resultArray.append(MovieResult(title: title, href: href, image: image,other: other))
                }
            }
            
            return resultArray
        }
        return []
    }
    
    func parseData(_ result:String,byXpath website: MovieSearchWebSite) -> [MovieResult] {
        if let _ = website.resultPath?.xpath,
           let doc = try? HTMLDocument(string: result, encoding: .utf8),
           let resultPath = website.resultPath {
        
            var resultArray: [MovieResult] = []
            
            let arr = doc.xpath(resultPath.xpath)
            for item in arr {
                
                var title = ""
                if let titleTag = resultPath.title,let titleEle = item.xpath(titleTag.xpath).first {
                    title = titleEle.attr(titleTag.key)
                }
                var href = ""
                if let hrefTag = resultPath.href, let hrefEle = item.xpath(hrefTag.xpath).first {
                    href = hrefEle.attr(hrefTag.key)
                    if !href.hasPrefix("http") {
                        href = website.baseUrl + (href.hasPrefix("/") ? "" : "/") + href
                    }
                }
                var image = ""
                if let imageTag = resultPath.image, let imgEle = item.xpath(imageTag.xpath).first {
                    image = imgEle.attr(imageTag.key)
                    if !imageTag.regex.isEmpty {
                        let array = image.subString(with: imageTag.regex)
                        if !array.isEmpty {
                            image = array[0]
                        }
                    }
                    if !image.isEmpty, !image.hasPrefix("http") {
                        image = website.baseUrl + image
                    }
                }
//                print("图片-----\(image)")
                var other: [String] = []
                if let otherXpaths = resultPath.other,!otherXpaths.isEmpty {
                    for htmlTag in otherXpaths {
                        if let ele = item.xpath(htmlTag.xpath).first {
                            other.append(ele.attr(htmlTag.key))
                        }
                    }
                }
                
                resultArray.append(MovieResult(title: title, href: href, image: image,other: other))
            }
            return resultArray
        }
        return []
    }
}
// MARK: - 扫描业务
extension Environment {
    
    /// 在处理结果中查找链接
    /// - Parameter results: 图片上识别出来的字符串结果集
    /// - Returns: 副作用
    func detectMagnet(_ results: [String]) -> AppAction {
//    magnet:?xt=urn:btih:开头(20) + 40位HASH值
//        ^(magnet:\?xt=urn:btih:)[0-9a-fA-F]{40}.*$/
        var prefix: String?
        var links: [String] = []
        for result in results {
            if result.hasPrefix("magnet:") {
                prefix = result
                if let link = magnetLink(from: result) {
                    links.append(link)
                }
            }else if let prefix = prefix {
                //只支持2行
                if let link = magnetLink(from: prefix + result) {
                    links.append(link)
                }
            }
        }
        return .updateMagnetLinks(links: links)
    }
    
    func magnetLink(from string: String) -> String? {
        print("\(string.count)    \(string)")
        guard string.count >= 60 else {
            return nil
        }
        return string.subString(with: "(magnet:\\?xt=urn:btih:)[0-9a-fA-F]{40}").first
    }
}

extension XMLElement {
    func attr(_ key: String) -> String {
        return key.isEmpty ? self.stringValue : (self[key] ?? "")
    }
}

// MARK: - 二维码相关业务

extension Environment {
    func createQrCode(_ qrCodeString: String,_ centerImage: UIImage?) -> AppAction {
        let size = 300 * UIScreen.main.scale
        if let image = UIImageHelper.shared.qrCode(from: qrCodeString, size: CGSize(width: size, height: size), centerImage: centerImage) {
            return .updateQrCodeImage(image: image)
        }
        return .empty
    }
    
    func saveToAlbum(_ image: UIImage) async -> AppAction {
        let success = await UIImageHelper.shared.saveImageToAlbum(image)
        return .updateToastMessage(message: success ? "保存成功" : "保存失败")
    }
}


extension Environment {
    /// 请求总页数
    /// - Parameter pageUrl: 网址
    /// - Returns: 页数
     func requestTotalPage(_ pageUrl: String) async -> Int {
        
        if let mainPage = await Switch520Request.loadHtml(pageUrl) {
            do {
                let doc: Document = try SwiftSoup.parse(mainPage)
                if let element = try doc.select("a[class=page-numbers]").last()?.html(),let total = Int(element) {
                    return total
                }
            } catch Exception.Error(let type, let message) {
                print("解析出错：\(type),\(message)")
            } catch {
                print("error")
            }
        }
        return 0
    }
    
    func fetchGamePage(_ pageUrl: String) async -> [Switch520Game] {
        var games: [Switch520Game] = []
        if let pageHtml = await Switch520Request.loadHtml(pageUrl) {
            do {
                let doc: Document = try SwiftSoup.parse(pageHtml)
                let elements = try doc.select("article")
                for element in elements {
                    if let id = try element.attr("id").split(separator: "-").second {
                        let imageUrl = try element.select("img.lazyload").attr("data-src")
                        let title = try element.select("h2").text()
                        let categorys = try element.select("a[rel=category]").map { try $0.text() }
                        let datetime = try element.select("time").attr("datetime")
                        let href = try element.select("h2").select("a").attr("href")
                        
//                        print("id:\(id)")
//                        print("imageUrl:\(imageUrl)")
//                        print("title:\(title)")
//                        print("categorys:\(categorys)")
//                        print("datetime:\(datetime)")
//                        print("href:\(href)")
                        
                        if let downloadInfoUrl = await Switch520Request.requestDownloadUrl(String(id)),
                           let downloadInfo = await Switch520Request.loadHtml(downloadInfoUrl),
                           let downloadInfoHtmlUrl = downloadInfo.regexUrlText.first,
                           let downloadInfoHtml = await Switch520Request.loadHtml(downloadInfoHtmlUrl)
                            {
                            
                            do {
                                let doc: Document = try SwiftSoup.parse(downloadInfoHtml)
                                let downloadAddress = try doc.select("meta[name=description]").attr("content")
                                
                                let game = Switch520Game(id: String(id), title: title, imageUrl: imageUrl, category: categorys, datetime: datetime, downloadAdress: downloadAddress)
                                
                                games.append(game)
                                print("✅ 请求成功：\(title)  \(pageUrl)")
                                
                            } catch Exception.Error(let type, let message) {
                                print("❌ 下载页 解析出错：\(title) \(type),\(message)")
                            } catch {
                                print("❌ 下载页 error: \(title)")
                            }
                        }else {
                            if let detailHtml = await Switch520Request.loadHtml(href) {
                                do {
                                    let doc: Document = try SwiftSoup.parse(detailHtml)
                                    let downloadAddress = try doc.select("div.entry-content").text()
                                    if let _ = downloadAddress.range(of: "https://pan.baidu.com") {
                                        let game = Switch520Game(id: String(id), title: title, imageUrl: imageUrl, category: categorys, datetime: datetime, downloadAdress: downloadAddress)
                                        games.append(game)
                                        print("✅ 请求成功：\(title)  \(pageUrl)")
                                    }else {
                                        print("❌ \(title)：无下载地址，是个汇总帖子")
                                    }
                                } catch Exception.Error(let type, let message) {
                                    print("❌ 详情页 解析出错：\(title) \(type),\(message)")
                                } catch {
                                    print("❌ 详情页 error: \(title)")
                                }
                            }else {
                                print("❌ \(title)：无下载地址，是个汇总帖子")
                            }
                        }
                    }
                }
            } catch Exception.Error(let type, let message) {
                print("❌ 列表页 解析出错：\(pageUrl) \(type),\(message)")
            } catch {
                print("❌ 列表页 error: \(pageUrl)")
            }
        }
        return games
    }
    
    func fetchGamePage(_ page: Int,_ pageUrl: String) async -> AppAction {
        let games = await fetchGamePage(pageUrl)
        return .fetchGamePageEnd(page: page, games: games)
    }
    
    func loadGames(_ mainPage: String,_ basePageUrl: String,_ fileName: String) async -> AppAction {
        guard let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return .loadGamesEnd(games: []) }
        let filePath = dirPath + "/" + fileName
        var url = URL.documentsDirectory.appending(path: fileName)
        if !FileHelper.fileExists(atPath: filePath),let fileUrl = Bundle.main.url(forResource: fileName, withExtension: nil) {
            url = fileUrl
        }
        
        if let json = try? String(contentsOf: url, encoding: .utf8),
           var games = [Switch520Game].deserialize(from: json)?.compactMap({ $0 }) {
            
            //不爬了
//            var gameIdSet = Set(games.map({ $0.id }))
//            //同步最新数据
//            let tatol = await requestTotalPage(mainPage)
//            var continueFetch = true
//            var needUpdateFile = false
//            if tatol > 0 {
//                for page in 1...tatol {
//                    let pageGames = await fetchGamePage(basePageUrl + String(page))
//                    for newGame in pageGames {
//                        if gameIdSet.contains(newGame.id) {
//                            continueFetch = false
//                            break
//                        }else {
//                            games.append(newGame)
//                            gameIdSet.insert(newGame.id)
//                            needUpdateFile = true
//                        }
//                    }
//                    if !continueFetch {
//                        break
//                    }
//                }
//            }
//            //更新文件
//            if needUpdateFile {
//                FileHelper.create(fileName: fileName, to: .documentDirectory, with: games.toJSONString()?.utf8Data)
//            }
            return .loadGamesEnd(games: games)
        }
        return .loadGamesEnd(games: [])
    }
}

extension Environment {
    func test(_ i: Int) async -> AppAction {
        print("work \(i) --- start")
        try? await Task.sleep(seconds: 0.5)
        print("work \(i) --- end")
        return .empty
    }
}
