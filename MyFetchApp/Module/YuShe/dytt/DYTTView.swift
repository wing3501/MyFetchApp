//
//  DYTTView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/26.
//

import SwiftUI
import Combine

struct DYTTView: View {
    @State var selectedTabIndex: Int = 0
    
    let cells = (0...20).map { value in
        Text("标题\(value)")
    }
    
    var body: some View {
        print("body create")
        return VStack {
            
            
            
            
        }
    }
}










struct DYTTView_Previews: PreviewProvider {
    static var previews: some View {
        DYTTView()
    }
}

