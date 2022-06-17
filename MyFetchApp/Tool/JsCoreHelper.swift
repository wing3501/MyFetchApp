//
//  JsCoreHelper.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/16.
//

import Foundation
import JavaScriptCore

class JsCoreHelper {
    public static let shared = JsCoreHelper()
    private var jsContext: JSContext
    
    init() {
        jsContext = JSContext(virtualMachine: JSVirtualMachine())
        jsContext.exceptionHandler = { context,exception in
            if let ex = exception {
                print("exception: \(String(describing: ex.toObject()))")
            }
        }
    }
    
//    let js = Bundle.main.string(from: "encodeToGb2312.js")!
//    let _ = JsCoreHelper.shared.evaluateJavaScript(js)
//    if let encodeName = JsCoreHelper.shared.evaluateJavaScript("encodeToGb2312('\(name)',true)"),let aaa = ooo as? String {
//        print("编码成功")
//    }
    
    func evaluateJavaScript(_ javaScript: String) -> Any? {
        let jsValue: JSValue = jsContext.evaluateScript(javaScript)
        return jsValue.toObject()
    }
}
