//
//  Task++.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/14.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    
  static func sleep(seconds: Double) async throws {
      let duration = UInt64(seconds * 1000_000_000)
      try await sleep(nanoseconds: duration)
  }
    
}
