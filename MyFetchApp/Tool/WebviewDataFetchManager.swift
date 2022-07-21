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
    
    /// 当前正在处理的请求
    var completionHandler: ((String) -> Void)?
    var tasks: [(URL,(String) -> Void)] = []
    
    @MainActor private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        var view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = self
        return view
    }()
    
    @MainActor private func dataString(with urlString: String,completionHandler: @escaping (String) -> Void) {
        if let url = URL(string: urlString) {
            tasks.append((url,completionHandler))
            
            if self.completionHandler == nil {
                startFetch()
            }
        }else {
            completionHandler("")
        }
    }
    
    @MainActor private func startFetch() {
        guard completionHandler == nil else { return }
        if !tasks.isEmpty {
            let (url,handler) = tasks.removeFirst()
            print("开始抓取----\(url)-----\(Thread.current)")
            completionHandler = handler
            webView.load(URLRequest(url: url))
        }
    }
    
    @MainActor func dataString(with url: String) async -> String {
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
        Task {
            await startFetch()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let handler = completionHandler {
            webView.evaluateJavaScript("document.documentElement.innerHTML") { [self] data, error in
                if let dataString = data as? String {
                    print("数据：\(dataString)")
                    handler(dataString)
                }else {
                    print("数据为空")
                    handler("")
                }
                print("结束抓取----\(webView.url!)")
                self.completionHandler = nil
                
                Task {
                    await startFetch()
                }
            }
        }else {
            Task {
                await startFetch()
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let handler = completionHandler {
            handler("")
            completionHandler = nil
        }
        Task {
            await startFetch()
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //解决-Code=-1202,Https服务器证书无效
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
        let serverTrust = challenge.protectionSpace.serverTrust {
            let card = URLCredential(trust: serverTrust)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, card)
        }
    }
}


