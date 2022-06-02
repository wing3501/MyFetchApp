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
        TabPageView(tab: { data in
            Text(data.title)
        }, page: { data in
            Text("page:\(data.title)")
        }, dataArray: store.appState.dytt.categoryData,sliderHeight: 4)
        .task {
            store.dispatch(.loadDyttData)
        }
    }
}

struct DyttView_Previews: PreviewProvider {
    static var previews: some View {
        DyttView().environmentObject(Store())
    }
}

