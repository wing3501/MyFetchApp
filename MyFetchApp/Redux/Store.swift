//
//  Store.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation
import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    
    var disposeBag = Set<AnyCancellable>()
    
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
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        
        
    }
    
    /// Reducer 的唯一职责是计算新的 State
    /// - Parameters:
    ///   - state: 原来的状态
    ///   - action: 触发状态变更的操作
    /// - Returns: 新的状态和副作用
    static func reduce(state: AppState,action: AppAction) -> (AppState,AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        if action is MainAction {
            
        }
        
        return (appState,appCommand)
    }
}
