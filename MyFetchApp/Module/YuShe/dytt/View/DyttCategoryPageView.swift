//
//  DyttCategoryPageView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/2.
//

import SwiftUI
import Refresh

struct DyttCategoryPageView: View {
    @EnvironmentObject var store: Store
    @State private var footerRefreshing: Bool = false
    @State private var noMore: Bool = false
    let category: DyttCategoryModel
    
    var body: some View {
        ScrollView {
            ForEach(category.dataArray) { item in
                DyttItemRow(itemModel: item)
            }
            
            if category.dataArray.count > 0 {
                RefreshFooter(refreshing: $footerRefreshing, action: {
                    self.loadMore()
                }) {
                    if self.noMore {
                        Text("No more data !")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ActivityIndicatorView()
                            .padding()
                    }
                }
                .noMore(noMore)
                .preload(offset: 50)
            }
        }
        .enableRefresh()
        .task {
            store.dispatch(.loadDyttCategoryPage(category: category))
        }
    }
    
    func loadMore() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.items += SimpleList.generateItems(count: 10)
//            self.footerRefreshing = false
//            self.noMore = self.items.count > 50
//        }
    }
}

struct DyttCategoryPageView_Previews: PreviewProvider {
    static var previews: some View {
        DyttCategoryPageView(category: DyttCategoryModel())
    }
}

