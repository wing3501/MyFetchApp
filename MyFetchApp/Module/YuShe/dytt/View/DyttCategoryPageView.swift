//
//  DyttCategoryPageView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/2.
//

import SwiftUI

struct DyttCategoryPageView: View {
    @EnvironmentObject var store: Store
    let model:DyttCategoryModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DyttCategoryPageView_Previews: PreviewProvider {
    static var previews: some View {
        DyttCategoryPageView(model: DyttCategoryModel())
    }
}
