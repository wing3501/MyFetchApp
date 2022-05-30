//
//  MainView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var store = Store()
    
    var mainViewState: AppState.MainView {
        store.appState.mainView
    }
    
    var mainViewBinding: Binding<AppState.MainView> {
        $store.appState.mainView
    }
    
    var body: some View {
        TabView(selection: mainViewBinding.selection) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }
                .tag(AppState.MainView.Index.home)
            AccountView()
                .tabItem {
                    Label("我的", systemImage: "person")
                }
                .tag(AppState.MainView.Index.account)
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
