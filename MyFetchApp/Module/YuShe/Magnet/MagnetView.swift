//
//  MagnetView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI

struct MagnetView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .hideTabView($store.appState.hideTabView)
    }
}

struct MagnetView_Previews: PreviewProvider {
    static var previews: some View {
        MagnetView()
    }
}
