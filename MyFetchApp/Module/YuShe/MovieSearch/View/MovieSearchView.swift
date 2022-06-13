//
//  MovieSearchView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/10.
//

import SwiftUI

struct MovieSearchView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
