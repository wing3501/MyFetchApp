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
    @Binding var category: DyttCategoryModel
    
    var body: some View {
        ScrollView {
            ForEach(category.dataArray) { item in
                DyttItemRow(itemModel: item)
            }
            
            if category.dataArray.count > 0 {
                RefreshFooter(refreshing: $category.footerRefreshing, action: {
                    self.loadMore()
                }) {
                    if category.noMore {
                        Text("No more data !")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ActivityIndicatorView()
                            .padding()
                    }
                }
                .noMore(category.noMore)
                .preload(offset: 50)
            }
        }
        .enableRefresh()
        .task {
            store.dispatch(.loadDyttCategoryPage(category: category))
        }
    }
    
    func loadMore() {
        store.dispatch(.dyttCategoryPageLoadMore(category: category))
    }
}

struct DyttCategoryPageView_Previews: PreviewProvider {
    static var previews: some View {
//        DyttCategoryPageView(category: DyttCategoryModel())
        EmptyView()
    }
}

