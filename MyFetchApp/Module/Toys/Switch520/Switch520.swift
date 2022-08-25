//
//  Switch520.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/2.
//

import SwiftUI

struct Switch520: View {
    
    var body: some View {
        // 从CoreData里读取数据
        GameDataInCoreData()
        // 直接从json文件里读取数据
//        GameDataInJson()
    }
}

// 从CoreData里读取数据
struct GameDataInCoreData: View {
    @EnvironmentObject var store: Store
    @State private var searchText = ""
    @State private var selectedItemDownloadAdress = ""
    
    @Namespace private var imageEffect
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(searchResults, id: \.self) { item in
                    let game = Switch520Game.game(from: item)
                    if store.appState.switch520.selectedGame?.id == game.id {
                        Spacer()
                    }else {
                        Switch520GameItemView(title: game.title, imageUrl: game.imageUrl, category: game.category, datetime: game.datetime, effectId: game.imageUrl, namespace: imageEffect)
                            .onTapGesture {
                                UIPasteboard.general.string = item.downloadAdress ?? ""
                                withAnimation {
                                    store.dispatch(.showGameDetail(game: game))
                                    store.dispatch(.showTopCoverView(coverView: detailView(selectedGame: game)))
                                }
                            }
                    }
                }
            }
            .padding(.horizontal,8)
        }
        .searchable(text: $searchText, prompt: "输入名称")
        .searchSuggestions({
            ForEach(searchResults, id: \.self) { result in
                Text(result.title ?? "")
                    .searchCompletion(result.title ?? "")
            }
        })
        .task {
            store.dispatch(.loadGameInCoreData)
        }
    }
    
    var searchResults: [Game] {
        if searchText.isEmpty {
            return store.appState.switch520.gamesCoreData
        } else {
            return store.appState.switch520.gamesCoreData.filter { game in
                if let title = game.title,title.contains(searchText) {
                    return true
                }
                return false
            }
        }
    }
    
    func detailView(selectedGame: Switch520Game) -> AnyView {
        Switch520GameDetailView(title: selectedGame.title, imageUrl: selectedGame.imageUrl, downloadAdress: selectedGame.downloadAdress, effectId: selectedGame.imageUrl, namespace: imageEffect) {
            store.dispatch(.closeGameDetail)
            store.dispatch(.closeTopCoverView)
        }
        .eraseToAnyView()
    }
    
//    var detailView: AnyView? {
//        if let selectedGame = store.appState.switch520.selectedGame {
//            return Switch520GameDetailView(title: selectedGame.title, imageUrl: selectedGame.imageUrl, downloadAdress: selectedGame.downloadAdress, effectId: selectedGame.imageUrl, namespace: imageEffect) {
//                withAnimation {
//                    store.dispatch(.closeGameDetail)
//                    store.dispatch(.closeTopCoverView)
//                }
//            }
//            .eraseToAnyView()
//        }
//        return nil
//    }
}

// 直接从json文件里读取数据
struct GameDataInJson: View {
    @EnvironmentObject var store: Store
    @State private var searchText = ""
    @State private var isShowAlert = false
    @State private var selectedItemDownloadAdress = ""
    @Namespace private var imageEffect
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(searchResults, id: \.self) { item in
                    Switch520GameItemView(title: item.title, imageUrl: item.imageUrl, category: item.category, datetime: item.datetime, effectId: item.imageUrl, namespace: imageEffect)
                        .onTapGesture {
                            UIPasteboard.general.string = item.downloadAdress
                            selectedItemDownloadAdress = item.downloadAdress
                            isShowAlert.toggle()
                        }
                }
            }
            .padding(.horizontal,8)
        }
        .searchable(text: $searchText, prompt: "输入名称")
        .searchSuggestions({
            ForEach(searchResults, id: \.self) { result in
                Text(result.title)
                    .searchCompletion(result.title)
            }
        })
        .task {
            store.dispatch(.loadGames)
        }
        .alert(isPresented: $isShowAlert) {
            
            Alert(title: Text("已复制到粘贴板"), message: Text(selectedItemDownloadAdress), dismissButton: .cancel(Text("知道了")))
        }
    }
    
    var searchResults: [Switch520Game] {
        if searchText.isEmpty {
            return store.appState.switch520.games
        } else {
            return store.appState.switch520.games.filter { $0.title.contains(searchText) }
        }
    }
}

struct Switch520_Previews: PreviewProvider {
    static var previews: some View {
        Switch520()
    }
}

