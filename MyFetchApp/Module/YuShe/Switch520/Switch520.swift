//
//  Switch520.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/2.
//

import SwiftUI

struct Switch520: View {
    
    @EnvironmentObject var store: Store
    @State private var searchText = ""
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(searchResults, id: \.self) { item in
                    Switch520GameItemView(item: item)
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

