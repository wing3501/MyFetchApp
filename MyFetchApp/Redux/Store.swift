//
//  Store.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class Store: ObservableObject {
//    @Published private(set) var appState = AppState() //有些第三方组件需要修改状态。破坏了所有在状态都在store修改的原则。但是用起来更方便一点。这里可以再权衡一下
    @Published var appState = AppState()
    private let environment = Environment()
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    /// 设置监听
    func setupObservers() {
        //网络监听
        
        //各模块功能监听
        
        //APP状态监听
        
        //...
        
        //业务监听
        appState.myQrCode.checker.wifiStringChanged.sink { wifiContent in
            self.dispatch(.updateWifiString(wifiString: wifiContent))
        }
        .store(in: &disposeBag)
    }
    
    /// 派发action
    /// - Parameter action: 更改状态的动作
    /// - Returns: 副作用任务
    @discardableResult
    func dispatch(_ action: AppAction) -> Task<Void, Never>? {
        Task {
            // 一个action可能产生多个副作用，且副作用task之间非结构化，所以用了task数组
            let tasks = reducer(state: &appState, action: action, environment: environment)
            for task in tasks {
                do {
                    //副作用产生的新action，继续派发
                    let action = try await task.value
                    dispatch(action)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    ///  action处理state,所有对state的修改都在这里
    /// - Parameters:
    ///   - state: 状态
    ///   - action: 更改状态的动作
    ///   - environment: 处理具体任务，并返回副作用
    /// - Returns: 副作用
    func reducer(state: inout AppState, action: AppAction, environment: Environment) -> [Task<AppAction, Error>] {
        switch action {
        case .empty:
            break
        case .loadDyttCategories:
            let url = state.dytt.mainPage
            return [Task {
                await environment.loadDyttCategories(url)
            }]
        case .updateDyttCategories(let categoryData):
            state.dytt.categoryData = categoryData
        case .loadDyttCategoryPage(let category):
            let host = state.dytt.host
            return [Task {
                await environment.loadDyttCategoryPage(host,category)
            }]
        case .updateDyttCategoryPage(let category, let items, let pageHrefs):
            category.dataArray = items
            category.pageHrefs = pageHrefs
        case .dyttCategoryPageLoadMore(let category):
            print("加载更多--------开始")
            category.footerRefreshing = true
            category.currentPage += 1
            let host = state.dytt.host
            return [Task {
                await environment.dyttCategoryPageLoadMore(host,category)
            }]
        case .updateDyttCategoryPageLoadMore(let category, let items, let pageHrefs):
            print("加载更多--------结束")
            category.dataArray = category.dataArray + items
            category.pageHrefs = category.pageHrefs + pageHrefs
            category.footerRefreshing = false
            category.noMore = category.currentPage == category.pageHrefs.count
        case .loadSearchSource:
            return [Task {
                await environment.loadSearchSource()
            }]
        case .updateSearchSource(let websites):
            state.movieSearch.websites = websites
            state.movieSearch.isButtonDisabled = websites.isEmpty
            return [Task {
//                try? await Task.sleep(nanoseconds: 1_000_000_000)
                return .dissmissLoading
            }]
        case .updateWebsite(let website,let index):
            state.movieSearch.requestFinishedCount = (state.movieSearch.requestFinishedCount ?? 0 ) + 1
            state.movieSearch.websites[index] = website
        case .searchMovie(let searchText):
            state.toastLoading = true
            state.movieSearch.requestFinishedCount = 0
            var tasks: [Task<AppAction, Error>] = []
            
            for i in 0..<appState.movieSearch.websites.count {
//            for i in 0..<1 {
                appState.movieSearch.websites[i].searchResult.removeAll()
                let website = appState.movieSearch.websites[i]
                tasks.append(Task { () -> AppAction in
                    let newWebsite = await environment.searchMovie(searchText, from: website)
                    return .updateWebsite(website: newWebsite, index: i)
                })
            }
            return tasks
        case .dissmissLoading:
            state.toastLoading = false
        case .detectMagnet(let image):
            print("开始识别图片")
//            state.toastLoading = true
            let results = VNDetectManager.shared.detectTextWithEn(from: image)
            return [Task {
                environment.detectMagnet(results)
            }]
        case .detectMagnetFrom(let text):
            let results = text.split(separator: "\n").map(String.init)
            return [Task {
                environment.detectMagnet(results)
            }]
        case .updateMagnetLinks(let links):
            if links.isEmpty {
                state.toastMessage = "未识别合适内容"
            }
//            state.toastLoading = false
            state.magnetState.magnetLinks = links
        case .updatePasteboardText(let text):
            UIPasteboard.general.string = text
            return [Task{
                return .updateToastMessage(message: "已复制到粘贴板")
            }]
        case .updateToastMessage(let message):
            state.toastMessage = message
        case .updateWifiString(let wifiString):
            state.myQrCode.qrcodeString = wifiString
        case .resetQrSetting:
            state.myQrCode.checker.wifiName = ""
            state.myQrCode.checker.wifiPassword = ""
            state.myQrCode.qrcodeString = ""
            state.myQrCode.qrCodeImage = nil
            state.myQrCode.centerImage = nil
        case .createQrCode(let qrCodeString):
            let centerImage = state.myQrCode.centerImage
            return [Task{
                return environment.createQrCode(qrCodeString,centerImage)
            }]
        case .updateQrCodeImage(let image):
            state.myQrCode.qrCodeImage = image
        case .cleanQrCenterImage:
            state.myQrCode.centerImage = nil
        case .saveToAlbum(let image):
            return [Task{
                return await environment.saveToAlbum(image)
            }]
        }
        return []
    }
}
