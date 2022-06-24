//
//  MovieSearchView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/10.
//

import SwiftUI
import ToastUI

struct MovieSearchView: View {
    
    @EnvironmentObject var store: Store
    @State var searchText = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack {
            if let finishedCount = store.appState.movieSearch.requestFinishedCount,finishedCount != store.appState.movieSearch.websites.count {
                ProgressView("", value: Double(finishedCount), total: Double(store.appState.movieSearch.websites.count))
            }
            List {
                HStack {
                    TextField("输入名称", text: $searchText)
    //                    .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                        .padding(.vertical,8)
                        .sideView(sideView: Image(systemName: "magnifyingglass"))
                        .sideView(sideView: Image(systemName: "delete.left"), position: .trailing) {
                            searchText = ""
                        }
                        .border(.gray, width: 1, cornerRadius: 8, style: .continuous)
                    Button("搜索") {
                        isFocused = false
                        if !searchText.isEmpty {
                            store.dispatch(.searchMovie(searchText: searchText))
                        }
                    }
                    .padding()
    //                .background(.yellow)
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(store.appState.movieSearch.isButtonDisabled)
                }
                ForEach(webSitesHasResult) { webSite in
                    NavigationLink(destination: MovieListView(movies: webSite.searchResult)) {
                        MovieWebSiteRow(website: webSite)
                    }
                }
            }
        }
//        .toast(isPresented: $store.appState.toastLoading, content: {
//            ToastView(store.appState.toastLoadingMessage)
//                .toastViewStyle(.indeterminate)
//        })
        .task {
            if store.appState.movieSearch.websites.isEmpty {
                store.dispatch(.loadSearchSource)
            }
        }
    }
    
    var webSitesHasResult: [MovieSearchWebSite] {
        store.appState.movieSearch.websites.filter({!$0.searchResult.isEmpty})
    }
}

struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchView()
    }
}
