//
//  WebviewDataFetchManager.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import UIKit
import WebKit

@MainActor
class WebviewDataFetchManager: NSObject {
    public static let shared = WebviewDataFetchManager()
    
    var completionHandler: ((String) -> Void)?
    @MainActor lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        var view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = self
        return view
    }()
    
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


