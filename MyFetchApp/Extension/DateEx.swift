//
//  DateEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation

/// 让@AppStorage 支持Date
extension Date: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let date = try? JSONDecoder().decode(Date.self, from: data) else {
            return nil
        }
        self = date
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data:data,encoding: .utf8) else {
            return ""
        }
       return result
    }
}
