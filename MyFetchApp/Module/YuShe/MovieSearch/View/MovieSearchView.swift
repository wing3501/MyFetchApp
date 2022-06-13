//
//  MovieSearchView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/10.
//

import SwiftUI

struct MovieSearchView: View {
    
    @EnvironmentObject var store: Store
    @State var searchText = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        List {
            HStack {
                TextField("输入名称", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .padding()
                Button("搜索") {
                    isFocused = false
                    store.dispatch(.searchMovie(searchText: searchText))
                }
                .background(.yellow)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .task {
            store.dispatch(.loadSearchSource)
        }
    }
}

struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchView()
    }
}
