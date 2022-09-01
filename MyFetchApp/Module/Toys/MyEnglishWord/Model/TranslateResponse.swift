//
//  TranslateResponse.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/31.
//

import Foundation

struct TranslateResponse: Decodable {
    let from: String
    let to: String
    let trans_result: [TranslateResult]
}

struct TranslateResult: Decodable {
    let src: String
    let dst: String
}
