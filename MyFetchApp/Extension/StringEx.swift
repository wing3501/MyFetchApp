//
//  StringEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/1.
//

import Foundation

extension String {
    var rangeOfAll: NSRange {
        NSMakeRange(0, self.count)
    }
    
    func substring(_ nsrange: NSRange) -> String.SubSequence {
        guard let range = Range(nsrange) else { return "" }
        return substring(range)
    }
    
    func substring(_ range: Range<Int>) -> String.SubSequence {
        //NSRange -> Range  endindex = location + length,所以需要-1
        substring(range.startIndex, range.endIndex - 1)
    }
    
    func substring(_ startIndex: Int,_ endIndex: Int) -> String.SubSequence {
        guard endIndex >= startIndex else { return "" }
        guard endIndex < self.count else { return "" }
        return self[(self.index(startIndex))...(self.index(endIndex))]
    }
    
    func index(_ index: Int) -> String.Index {
        self.index(self.startIndex, offsetBy: index)
    }
}


//var str = "Hello, playground"
//print(str[(str.index(str.startIndex, offsetBy: 1))...(str.index(str.startIndex, offsetBy: 3))])
