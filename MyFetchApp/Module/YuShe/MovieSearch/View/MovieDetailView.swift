//
//  MovieDetailView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/16.
//

import SwiftUI
import SwiftUIX

struct MovieDetailView: View {
    let url: String
    var body: some View {
        WebView(url: url) {
            Text("\(url)\n详情加载中~")
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(url: "https://www.baidu.com/")
    }
}
