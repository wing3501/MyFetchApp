//
//  AppAction.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation

protocol AppAction {}

//每个业务模块触发状态变更的action
enum MainAction: AppAction {
    case logon
}
enum AccountActon: AppAction {
    
}
