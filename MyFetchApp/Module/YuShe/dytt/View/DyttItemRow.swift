//
//  DyttItemRow.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/2.
//

import SwiftUI
import Kingfisher

struct DyttItemRow: View {
    @State private var isExpanding = false
    let itemModel: DyttItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Text(itemModel.title)
                .font(.headline)
                .foregroundColor(.green)
//                .background(.random)
            Text(itemModel.subTitle)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(itemModel.desc)
                .font(.body)
                .foregroundColor(.blue)
//                .background(.random)
                .lineLimit(isExpanding ? nil : 1)
        }
        .animation(.default, value: isExpanding)
        .onTapGesture {
//            withAnimation { //显式动画导致动画弹跳
                isExpanding.toggle()
//            }
        }
    }
}




struct DyttItemRow_Previews: PreviewProvider {
    static var previews: some View {
        DyttItemRow_Previews_ContentView()
    }
}

struct DyttItemRow_Previews_ContentView: View {
    @State var isExpanding = false
    var body: some View {
        List {
            DyttItemRow(itemModel: DyttItemModel(title: "1", subTitle: "2", desc: "3", href: ""))
        }
    }
}

