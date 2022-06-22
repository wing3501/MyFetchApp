//
//  TestView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI

struct TestView: View {
    @State var text: String = ""
    
    var body: some View {
        TextField("输入内容1", text: $text)
            .frame(width: 300, height: 60)
            .sideView(sideView: Image(systemName: "delete.left"), position: .trailing)
            .border(.red, cornerRadius: 8)

    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
