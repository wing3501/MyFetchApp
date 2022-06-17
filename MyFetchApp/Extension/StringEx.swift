//
//  StringEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/1.
//

import Foundation
import Alamofire

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
    
    subscript(_ closeRange: ClosedRange<Int>) -> String.SubSequence {
        substring(closeRange.lowerBound, closeRange.upperBound)
    }
    
    // MARK: - 编码
    
    func URLEncode() -> String {
        guard let encoded = addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else { return "" }
        return encoded
    }
    
    func URLDecode() -> String {
        guard let decoded = removingPercentEncoding else { return "" }
        return decoded
    }
    
    var gb2312: Data {
        guard let data = self.data(using: .gb2312) else { return Data() }
        return data
    }
    
    // MARK: - 正则
    var isNumberText: Bool {
        let regex = "^[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}


//var str = "Hello, playground"
//print(str[(str.index(str.startIndex, offsetBy: 1))...(str.index(str.startIndex, offsetBy: 3))])
