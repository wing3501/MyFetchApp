//
//  DyttCategoryPageView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/2.
//

import SwiftUI

struct DyttCategoryPageView: View {
    @EnvironmentObject var store: Store
    let category: DyttCategoryModel
    
    var body: some View {
        List(category.dataArray) { item in
            DyttItemRow(itemModel: item)
        }
        .task {
            store.dispatch(.loadDyttCategoryPage(category: category))
        }
    }
}

struct DyttCategoryPageView_Previews: PreviewProvider {
    static var previews: some View {
        DyttCategoryPageView(category: DyttCategoryModel())
    }
}

