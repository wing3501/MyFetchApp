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
    @Published private(set) var appState = AppState()
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
    
    @discardableResult
    func dispatch(_ action: AppAction) -> Task<Void, Never>? {
        Task {
            if let task = reducer(state: &appState, action: action, environment: environment) {
                do {
                    //副作用产生的新action
                    let action = try await task.value
                    dispatch(action)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func reducer(state: inout AppState, action: AppAction, environment: Environment) -> Task<AppAction, Error>? {
        switch action {
        case .empty:
            break
        case .loadDyttData:
            return Task {
                await environment.loadDyttData()
            }
        case .updateDyttMainPage(let dataString):
            print("请求到数据-----")
            print(dataString)
        }
        return nil
    }
}
