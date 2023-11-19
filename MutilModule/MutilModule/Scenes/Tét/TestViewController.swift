//
//  TestViewController.swift
//  MutilModule
//
//  Created by NguyenHao on 03/11/2023.
//

import UIKit
import WebKit


final class TestViewcontroller: UIViewController, WKUIDelegate, WKNavigationDelegate {
    private let schemes: [String] = ["mailto:", "tel:", "itms-appss://"]
    
    private var webView: WKWebView = {
//        let configure = WKWebViewConfiguration()
//        let userContent = WKUserContentController()
//        configure.userContentController = userContent
//        configure.mediaTypesRequiringUserActionForPlayback = .init(rawValue: 0)
//        configure.allowsInlineMediaPlayback = true
        let wv = WKWebView(frame: .zero)
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let url = URL(string: "https://skshd.gotrust.vn/?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmdWxsTmFtZSI6Ik5HVVlFTiBBTkggSEFPIiwicGhvbmUiOiIwOTQyNjYxMDYwIiwiZXhwIjoxNjk5NDE2Mjk1fQ.Kl_1f67MeNQp5BX6N7wc_scXRRcP4qnX1yyURXXRxHY")
        webView.load(URLRequest.init(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        hideLoading()
        manageFailedNavigation(webView, didFail: navigation, withError: error)
    }
    
    
    private func manageFailedNavigation(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nsError = error as NSError
        let errorCodeTimout = -1001
        if let failedURL = nsError.userInfo["NSErrorFailingURLKey"] as? URL,
           canOpen(string: failedURL.absoluteString),
           UIApplication.shared.canOpenURL(failedURL) {
            UIApplication.shared.open(failedURL)
        } else if nsError.code == errorCodeTimout {
//            VNPAlertController.showAlert("Kết nối bị gián đoạn. Quý khách vui lòng thử lại sau".localize, block: nil)
            return
        }
    }
    
    private func canOpen(string: String) -> Bool {
        for scheme in schemes {
            if(string.hasPrefix(scheme)) {
                return true
            }
        }
        return false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == .linkActivated  {
        print(navigationAction.request.url?.host)
            if let url = navigationAction.request.url,
               let host = url.host, host.hasPrefix("dnjdsnfjnsjfnjkdsnkf"),
               UIApplication.shared.canOpenURL(url) {
                print(url)
                print("No need to open it locally")
                decisionHandler(.cancel)
                return
            } else {
                print("Open it locally")
                decisionHandler(.allow)
                return
            }
//        decisionHandler(.allow)
//        } else {
//            print("not a user click")
//            decisionHandler(.allow)
//        }
    }
}
