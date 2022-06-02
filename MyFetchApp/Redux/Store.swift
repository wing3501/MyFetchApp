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
    
    /// 派发action
    /// - Parameter action: 更改状态的动作
    /// - Returns: 副作用任务
    @discardableResult
    func dispatch(_ action: AppAction) -> Task<Void, Never>? {
        Task {
            if let task = reducer(state: &appState, action: action, environment: environment) {
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
    func reducer(state: inout AppState, action: AppAction, environment: Environment) -> Task<AppAction, Error>? {
        switch action {
        case .empty:
            break
        case .loadDyttData:
            return Task {
                await environment.loadDyttData()
            }
        case .updateDyttMainPage(let categoryData):
            state.dytt.categoryData = categoryData
        }
        return nil
    }
}
