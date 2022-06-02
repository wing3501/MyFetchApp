//
//  DYTTView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/26.
//

import SwiftUI
import Combine

struct DYTTView: View {
    @EnvironmentObject var store: Store
    @State var selectedTabIndex: Int = 0
    
    
    var body: some View {
        
         VStack {
            
            

        }
        .task {
            store.dispatch(.loadDyttData)
        }
    }
}

struct DYTTView_Previews: PreviewProvider {
    static var previews: some View {
        DYTTView()
    }
}

