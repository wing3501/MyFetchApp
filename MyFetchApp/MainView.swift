//
//  MainView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import SwiftUI

enum MainTabIndex: Hashable {
    case home,account
}

struct MainView: View {
    
    @StateObject var store: Store
    @State var selection: MainTabIndex = .home
    
    init() {
        _store = StateObject(wrappedValue: Store())
        
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }
                .tag(MainTabIndex.home)
            AccountView()
                .tabItem {
                    Label("我的", systemImage: "person")
                }
                .tag(MainTabIndex.account)
        }
        .edgesIgnoringSafeArea(.top)
        .environmentObject(store)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
