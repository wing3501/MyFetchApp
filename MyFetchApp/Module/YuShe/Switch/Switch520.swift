//
//  Switch520.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/2.
//

import SwiftUI

struct Switch520: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
//                store.dispatch(.fetchSwitch520TotalPage)
                store.dispatch(.fetchGamePage(page: 1))
            }
    }
}

struct Switch520_Previews: PreviewProvider {
    static var previews: some View {
        Switch520()
    }
}
