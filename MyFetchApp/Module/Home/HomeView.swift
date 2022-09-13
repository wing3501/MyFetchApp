//
//  HomeView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/25.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    let titleArray = ["电影资源搜索","图片识别磁力链接","扫描文档","二维码生成","Switch520游戏"]
    let iconArray = ["film","photo","doc.text","qrcode","gamecontroller"]
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationStack(path: $store.appState.navigationPath) {
            List {
                ForEach(0..<titleArray.count, id: \.self) { index in
                    NavigationLink(value: index) {
                        HomeViewListRow(websiteName: titleArray[index], SFIcon: iconArray[index])
                    }
                }
            }
            .navigationDestination(for: Int.self) { index in
                switch index {
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
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
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
