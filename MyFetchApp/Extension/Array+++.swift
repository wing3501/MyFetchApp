//
//  ArrayEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation

/// 让@AppStorage 支持Array
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Array {
    var second: Element? {
        if self.count > 1 {
            return self[1]
        }
        return nil
    }
}
