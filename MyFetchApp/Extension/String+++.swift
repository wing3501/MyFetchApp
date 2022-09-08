//
//  String+++.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/1.
//

import Foundation
import Alamofire
import CommonCrypto

extension String: Identifiable {
    public typealias ID = String
    public var id: String {
        self
    }
}

// MARK: - 随机数
extension String {
    enum RandomSource: String {
        case AZaz09 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        case az09 = "abcdefghijklmnopqrstuvwxyz0123456789"
        case num = "0123456789"
    }
    
    /// 生成一串随机字符串
    static func random(source: RandomSource = .AZaz09,count: Int) -> String {
        var array: [Character] = []
        let sourceString = source.rawValue
        var i = 0
        while i < count{
            if let ch = source.rawValue.randomElement() {
                array.append(ch)
                
            }else {
                array.append("0")
            }
            i += 1
        }
        return String(array)
    }
}

// MARK: - 子串
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
}


// MARK: - 编码
extension String {
    var URLEncode: String {
        guard let encoded = addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else { return "" }
        return encoded
    }
    
    var URLDecode: String {
        guard let decoded = removingPercentEncoding else { return "" }
        return decoded
    }
    
    var gb2312: Data {
        guard let data = self.data(using: .gb2312) else { return Data() }
        return data
    }
    
    var utf8Data: Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return data
    }
    // 处理字符串中的html编码
    var decodedHtml: String {
      let attr = try? NSAttributedString(
        data: Data(utf8),
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil)

      return attr?.string ?? self
    }
}

// MARK: - 正则
extension String {
    var isNumberText: Bool {
        let regex = "^[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isUrlText: Bool {
        let regex = "((ht|f)tps?):\\/\\/[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\.,@?^=%&:\\/~\\+#]*[\\w\\-\\@?^=%&\\/~\\+#])?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var regexUrlText: [String] {
        let regex = "((ht|f)tps?):\\/\\/[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\.,@?^=%&:\\/~\\+#]*[\\w\\-\\@?^=%&\\/~\\+#])?"
        return subString(with: regex)
    }
    
    func subString(with regex: String) -> Array<String> {
        var array: [String] = []
        if let regularExpression = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) {
            let results = regularExpression.matches(in: self, range: rangeOfAll)
            for item in results {
                let subString = String(self.substring(item.range))
                if !subString.isEmpty {
                    array.append(subString)
                }
            }
        }
        return array
    }
}


// MARK: - json
extension String {
    /// json字符串转字典
    var toDictionary: Dictionary<String,Any>? {
        (try? JSONSerialization.jsonObject(with: self.utf8Data)) as? Dictionary<String,Any>
    }
    
    /// json字符串转数组
    var toArray: Array<Any>? {
        (try? JSONSerialization.jsonObject(with: self.utf8Data)) as? Array<Any>
    }
    
    /// 根据keypath从json字符串中取出值
    /// - Parameter keypath: / [] 分割的keypath
    /// - Returns: 值
    /// jsonString.jsonValue(for: "name")
    /// jsonString.jsonValue(for: "info/age")
    /// jsonString.jsonValue(for: "friend[1]")
    /// jsonString.jsonValue(for: "others[1]/title")
    /// jsonString.jsonValue(for: "[1]")
    func jsonValue(for keypath: String) -> Any? {
        let keys = keypath.split(separator: "/").map({ String($0) })
        if !keys.isEmpty,
            let jsonData = self.data(using: .utf8),
            var json = try? JSONSerialization.jsonObject(with: jsonData) {
            
            var index = 0
            while index < keys.count {
                let key = keys[index]
                if let left = key.firstIndex(of: "["),let right = key.firstIndex(of: "]") {
                    //当前key是数组形式
                    if let arrIndex = Int(key[key.index(after: left)..<right]) {
                        if key.hasPrefix("[") {
                            //[1]/age
                            if let arr = json as? Array<Any> {
                                json = arr[arrIndex]
                            }else {
                                return nil
                            }
                        }else {
                            //name[1]/age
                            if let dic = json as? Dictionary<String,Any>, let arr = dic[String(key[..<left])] as? Array<Any> {
                                json = arr[arrIndex]
                            }else {
                                return nil
                            }
                        }
                    }else {
                        //无法提取出数组下标，keypath格式有误
                        return nil
                    }
                    
                }else {
                    //当前key是字典形式
                    if let dic = json as? Dictionary<String,Any>,let val = dic[key] {
                        json = val
                    }else {
                        return nil
                    }
                }
                
                index += 1
                
                if index == keys.count {
                    return json
                }
            }
        }
        return nil
    }
}





