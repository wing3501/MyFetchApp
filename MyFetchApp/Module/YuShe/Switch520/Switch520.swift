//
//  Switch520.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/2.
//

import SwiftUI

struct Switch520: View {
    
    @EnvironmentObject var store: Store
    
    init() {
        
    }
    
    var body: some View {
        Button("保存", action: {
            store.dispatch(.saveGames)
        })
            .task {
                store.dispatch(.fetchSwitch520TotalPage(needFetch: true))
//                store.dispatch(.fetchGamePage(page: 191))
            }
    }
}

struct Switch520_Previews: PreviewProvider {
    static var previews: some View {
        Switch520()
    }
}
