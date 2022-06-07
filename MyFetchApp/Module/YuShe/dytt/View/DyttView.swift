//
//  DyttView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/26.
//

import SwiftUI
import Combine

struct DyttView: View {
    @EnvironmentObject var store: Store
    @State var selectedTabIndex: Int = 0
    
    
    var body: some View {
        TabPageView(tab: { data,index in
            Text(data.title)
        }, page: { data,index in
            DyttCategoryPageView(category: $store.appState.dytt.categoryData[index])
        }, dataArray: store.appState.dytt.categoryData,sliderHeight: 4)
        .task {
            store.dispatch(.loadDyttCategories)
        }
    }
}

struct DyttView_Previews: PreviewProvider {
    static var previews: some View {
        DyttView().environmentObject(Store())
    }
}

