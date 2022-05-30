//
//  Environment.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation


/// 副作用处理
final class Environment {
    func setAge(age: Int) async -> AppAction {
        print("set age")
        return .empty
    }

    func setName(name: String) async -> AppAction {
        print("set Name")
        await Task.sleep(2 * 1000000000)
        return .setAge(age: Int.random(in: 0...100))
    }
    
    func loadDyttData() async -> AppAction {
        let dataString = await DyttRequest.loadMainPage()
        return .updateDyttMainPage(data: dataString)
    }
}
