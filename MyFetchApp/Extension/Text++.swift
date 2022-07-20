//
//  Text++.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/14.
//

import SwiftUI

extension Text {
    
//    Text("GAME OVER") { $0.kern = CGFloat(2) }
    
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
       var attributedString = AttributedString(string) /// create an `AttributedString`
       configure(&attributedString)
       self.init(attributedString)
    }
}
 
