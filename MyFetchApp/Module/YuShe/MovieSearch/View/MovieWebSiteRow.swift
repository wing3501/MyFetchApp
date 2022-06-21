//
//  MovieWebSiteRow.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/15.
//

import SwiftUI
import Kingfisher

struct MovieWebSiteRow: View {
    
    let website: MovieSearchWebSite
    
    var body: some View {
        HStack {
            if !website.icon.isEmpty {
                KFImage(URL(string: website.icon)) 
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 70)
                .padding(.trailing ,20)
            }
            
            VStack(spacing: 10) {
                Text(website.name)
                Text("总共 \(website.searchResult.count) 条")
            }
            
        }
    }
}

struct MovieWebSiteRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MovieWebSiteRow(website: MovieSearchWebSite())
//            EmptyView()
        }
    }
}
