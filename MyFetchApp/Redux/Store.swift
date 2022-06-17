//
//  Store.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
//    @Published private(set) var appState = AppState() //有些第三方组件需要修改状态
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
            state.ms.websites = websites
            return [Task {
//                try? await Task.sleep(nanoseconds: 1_000_000_000)
                return .dissmissLoading
            }]
        case .updateWebsite(let website,let index):
            state.ms.websites[index] = website
        case .searchMovie(let searchText):
            state.ms.isRequestLoading = true
            var tasks: [Task<AppAction, Error>] = []
            
//            for i in 0..<appState.ms.websites.count {
            for i in 0..<1 {
                let website = appState.ms.websites[i]
                tasks.append(Task { () -> AppAction in
                    let newWebsite = await environment.searchMovie(searchText, from: website)
                    return .updateWebsite(website: newWebsite, index: i)
                })
            }
            return tasks
        case .dissmissLoading:
            state.ms.isRequestLoading = false
        }
        return []
    }
}
