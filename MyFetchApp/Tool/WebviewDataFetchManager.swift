//
//  WebviewDataFetchManager.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import UIKit
import WebKit

class WebviewDataFetchManager: NSObject {
    public static let shared = WebviewDataFetchManager()
    let webView: WKWebView
    var completionHandler: ((String) -> Void)?
    
    override init() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        webView.navigationDelegate = self
    }
    
    func dataString(with url: String,completionHandler: @escaping (String) -> Void) {
        self.completionHandler = completionHandler
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    func dataString(with url: String) async -> String {
        await withCheckedContinuation { continuation in
            dataString(with: url) { string in
                continuation.resume(returning: string)
            }
        }
    }
}

extension WebviewDataFetchManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let handler = completionHandler {
            webView.evaluateJavaScript("document.documentElement.innerHTML") { data, error in
                if let dataString = data as? String {
                    handler(dataString)
                }else {
                    handler("")
                }
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let handler = completionHandler {
            handler("")
        }
    }
}


