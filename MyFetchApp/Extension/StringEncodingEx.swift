//
//  StringEncodingEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation

extension String.Encoding{
    public static let gb2312: String.Encoding = .init(rawValue:CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}
