//
//  AppCommand.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import Foundation

protocol AppCommand {
    //参数 Store 则提供了一个执行后续操作的上下文，让我们可以在副作用执行完毕时，继续 发送新的 Action 来更改 app 状态
    func execute(in store: Store)
}
