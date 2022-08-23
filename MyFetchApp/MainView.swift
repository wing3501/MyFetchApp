//
//  MainView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import SwiftUI

struct MainView: View {
    
    enum MainTabIndex: Hashable {
        case home,account
    }
    
    @StateObject var store: Store
    @State var selection: MainTabIndex = .home
    
    init() {
        _store = StateObject(wrappedValue: Store())
    }
    
    var body: some View {
        NavigationStack(path: $store.appState.navigationPath) {
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        if !store.appState.hideTabView {
                            Label("首页", systemImage: "house")
                        }
                        
                    }
                    .tag(MainTabIndex.home)
                AccountView()
                    .tabItem {
                        if !store.appState.hideTabView {
                            Label("我的", systemImage: "person")
                        }
                    }
                    .tag(MainTabIndex.account)
            }
            .edgesIgnoringSafeArea(.top)
            .navigationDestination(for: Int.self) { index in
                switch index {
    //                case 0:
    //                    DyttView()
                case 0:
                    MovieSearchView()
                case 1:
                    MagnetView()
                case 2:
                    DocumentScanView()
                case 3:
                    MyQrCodeView()
                case 4:
                    Switch520()
                default:
                    EmptyView()
                }
            }
        }
        .environmentObject(store)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
