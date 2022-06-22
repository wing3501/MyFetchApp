//
//  MagnetView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI

struct MagnetView: View {
    
//    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            HStack {
                Button {
                } label: {
                    Text("从相册选择")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(.green)
                .buttonStyle(BorderlessButtonStyle())
                
                Button {
                    
                } label: {
                    Text("扫一扫")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(.orange)
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            .padding(.top,80)
            GroupBox("结果如下(点击可复制)：") {
                VStack(alignment: .leading) {
                    Text("Username: tswift89")
                    Text("City: Nashville")
                    GroupBox {
                        Text("City: Nashville")
                    }
                }
            }
            .padding()
            Spacer()
        }
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .hideTabView($store.appState.hideTabView)
    }
}

struct MagnetView_Previews: PreviewProvider {
    static var previews: some View {
        MagnetView()
    }
}
