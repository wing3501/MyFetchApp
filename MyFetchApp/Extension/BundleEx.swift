//
//  BundleEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/7.
//

import UIKit

extension Bundle {
    
    //let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
    
    /// 读取Bundle中的文件为字符串
    /// - Parameter file: 文件名
    /// - Returns: 文件内容
    func string(from file: String) -> String? {
        if let fileUrl = url(forResource: file, withExtension: nil),
           let data = try? Data(contentsOf: fileUrl),
           let fileString = String(data: data, encoding: .utf8) {
            return fileString
        }
        return nil
    }
}

