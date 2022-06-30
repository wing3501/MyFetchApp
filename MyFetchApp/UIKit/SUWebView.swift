//
//  SUWebView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation
import SwiftUI
import WebKit

struct SUWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    var webView: WKWebView
    
    init(url: String? = nil,config: WKWebViewConfiguration? = nil,uiDelegate: WKUIDelegate? = nil,navigationDelegate: WKNavigationDelegate? = nil) {
        let webviewVonfig = config ?? WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webviewVonfig)
        let insideDelegate = SUWebViewDelegate()
        webView.uiDelegate = uiDelegate ?? insideDelegate
        webView.navigationDelegate = navigationDelegate ?? insideDelegate
        if let url = url,let loadURL = URL(string: url) {
            webView.load(URLRequest(url: loadURL))
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("webView makeUIView")
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("webView updateUIView")
    }
    
    func evaluateJavaScript(_ javaScriptString: String) {
        webView.evaluateJavaScript(javaScriptString) { data, error in
            if let dataString = data as? String {
                print("js执行结果----\(dataString)")
            }
        }
    }
}

class SUWebViewDelegate: NSObject {
    
}

extension SUWebViewDelegate: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        //由原生来唤起弹窗
//        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
//            completionHandler()
//        }))
//        present(alertVC, animated: true)
    }
    
    //调用 JS 的 confirm 方法
    func webView(_ WebView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
//            completionHandler(true)
//        }))
//        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
//            completionHandler(false)
//        }))
//        present(alertVC, animated: true)
    }
    
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo) async -> String? {
        //客户端可以通过下面的方法获取到输入框事件，并由客户端展示输入框，用户输入完成后将结果回调给completionHandler中。
        
//        let alertVC = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
//        alertVC.addTextField { textFiled in
//            textFiled.text = defaultText
//        }
//        alertVC.addAction(UIAlertAction(title: "完成", style: .default, handler: { action in
//            completionHandler(alertVC.textFields?[0].text ?? "")
//        }))
//        present(alertVC, animated: true)
//    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("通知 App，DOM 窗口已成功关闭 webViewDidClose...")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        经常用于在项目中处理 H5 界面中含有 target = __blank 标签（表示新建一个页面打开网页）或者网页中点击无响应的情况，其处理逻辑主要是判断目标主视图是否为空，如果不为空则允许导航。
        if navigationAction.targetFrame?.isMainFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension SUWebViewDelegate: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
//        这里可以对域名进行判断，如果是站外域名，则可以提示用户是否进行跳转。
//        如果是跳转其他App或商店的URL，则可以通过openURL进行跳转，并将这次请求拦截。
//        包括cookie的处理也在此方法中完成，
        if let url = navigationAction.request.url {
            print("decidePolicyFor:\(url)")
        }
        return .allow
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载页面，并请求服务器 didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败 didFailProvisionalNavigation")
//        当页面加载失败的时候，会回调此方法，包括timeout等错误。
//        在这个页面可以展示错误页面，清空进度条，重置网络指示器等操作。
//        需要注意的是，调用goBack时也会执行此方法，可以通过error的状态判断是否NSURLErrorCancelled来过滤掉。
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        页面加载及渲染完成，会调用此方法，调用此方法时H5的dom已经解析并渲染完成，展示在屏幕上。
//        所以在此方法中可以进行一些加载完成的操作，例如移除进度条，重置网络指示器等。
        print("加载完成 didFinish ---\(webView.url?.absoluteString ?? "")")
        
//        webView.evaluateJavaScript("navigator.userAgent") { data, error in
//            if let dataString = data as? String {
//                print("看看----\(dataString)")
//            }
//        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        开始获取到网页内容时返回
    }
}
