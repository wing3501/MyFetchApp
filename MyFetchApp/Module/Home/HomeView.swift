//
//  HomeView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: DyttView().navigationBarTitle("电影天堂", displayMode: .inline)) {
                        HomeViewListRow(logoUrl: "https://www.ygdy8.com/images/logo.gif", SFIcon: "play.rectangle")
                    }
                    NavigationLink(destination: MovieSearchView().navigationBarTitle("电影资源搜索", displayMode: .inline)) {
                        HomeViewListRow(websiteName: "电影资源搜索", SFIcon: "film")
                    }
                    NavigationLink(destination: MagnetView().navigationBarTitle("图片识别磁力链接", displayMode: .inline)) {
                        HomeViewListRow(websiteName: "图片识别磁力链接", SFIcon: "photo")
                    }
                    NavigationLink(destination: DocumentScanView().navigationBarTitle("扫描文档", displayMode: .inline)) {
                        HomeViewListRow(websiteName: "扫描文档", SFIcon: "doc.text")
                    }
                } header: {
                    Text("预设网站抓取")
                }
                Section {
                    DisableHomeViewListRow()
                } header: {
                    Text("预设API抓取")
                }
                Section {
                    DisableHomeViewListRow()
                } header: {
                    Text("自定义抓取")
                }
            }
        }
    }
}

struct HomeViewListRow: View {
    let logoUrl: String?
    let websiteName: String?
    let SFIcon: String

    init(logoUrl: String? = nil,websiteName: String? = nil,SFIcon: String) {
        self.logoUrl = logoUrl
        self.websiteName = websiteName
        self.SFIcon = SFIcon
    }
    
    var body: some View {
        VStack {
            if let logoUrl = logoUrl {
                VStack(alignment: .center) {
                    KFImage(URL(string: logoUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            } else if let websiteName = websiteName {
                HStack {
                    Text(websiteName)
                        .padding()
                    Image(systemName: SFIcon)
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 100)
    }
}

struct DisableHomeViewListRow: View {
    var body: some View {
        VStack {
            Text("暂未开发")
        }
        .frame(height: 50, alignment: .leading)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
