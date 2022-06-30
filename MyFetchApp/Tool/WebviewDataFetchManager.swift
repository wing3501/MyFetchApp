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
    
    /// 当前正在处理的请求
    var completionHandler: ((String) -> Void)?
    var tasks: [(URL,(String) -> Void)] = []
    
    @MainActor lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        var view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = self
        return view
    }()
    
    func dataString(with urlString: String,completionHandler: @escaping (String) -> Void) {
        if let url = URL(string: urlString) {
            tasks.append((url,completionHandler))
            
            if self.completionHandler == nil {
                startFetch()
            }
        }else {
            completionHandler("")
        }
    }
    
    func startFetch() {
        guard completionHandler == nil else { return }
        if !tasks.isEmpty {
            let (url,handler) = tasks.removeFirst()
            print("开始抓取----\(url)-----\(Thread.current)")
            completionHandler = handler
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,let _ = url.absoluteString.range(of: "google") {
            decisionHandler(.cancel)
        }else {
            decisionHandler(.allow)
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        if let handler = completionHandler {
            handler("")
            completionHandler = nil
        }
        startFetch()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let handler = completionHandler {
            webView.evaluateJavaScript("document.documentElement.innerHTML") { data, error in
                if let dataString = data as? String {
                    handler(dataString)
                }else {
                    handler("")
                }
                print("结束抓取----\(webView.url!)")
                self.completionHandler = nil
                self.startFetch()
            }
        }else {
            startFetch()
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let handler = completionHandler {
            handler("")
            completionHandler = nil
        }
        startFetch()
    }
}


