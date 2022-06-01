//
//  DispatchQueueEx.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/27.
//

import Foundation

extension DispatchQueue {
    static func mainAsyncOrExecute(_ work: @escaping () -> Void) {
        if Thread.current.isMainThread {
            work()
        } else {
            main.async {
                work()
            }
        }
    }
    
    static func mainAsync(after seconds: Double,_ work: @escaping () -> Void) {
        main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: work)
    }
}
