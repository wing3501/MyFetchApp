//
//  MyFetchApp.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import SwiftUI

@main
struct MyFetchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
