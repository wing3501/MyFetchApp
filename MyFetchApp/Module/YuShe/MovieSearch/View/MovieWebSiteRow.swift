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
                KFImage(URL(string: website.icon)) //"https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
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
