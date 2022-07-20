//
//  Global.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/13.
//

import Foundation

func objAddress<T: AnyObject>(o: T) -> String {
   return String.init(format: "%018p", unsafeBitCast(o, to: Int.self))
}


