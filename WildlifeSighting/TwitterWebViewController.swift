//
//  TwitterWebViewController.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit
import WebKit

class TwitterWebViewController: UIViewController, WKUIDelegate,  WKNavigationDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    var webView: WKWebView!
    
    private func setUpWebView() {
        self.edgesForExtendedLayout = []
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.insertSubview(webView, belowSubview: progressView)
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        navigationController?.setToolbarHidden(false, animated: false)
        super.viewDidLoad()
        setUpWebView()
        let myURL = URL(string: "https://fieldbook.com/sheets/58757bb45de269040063ab7e/n1")
        let myRequest = URLRequest(url: myURL!)
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    @IBAction func browserButtonPressed(_ sender: UIBarButtonItem) {
        switch sender {
        case backButton:
            webView.goBack()
        case reloadButton:
            let request = URLRequest(url: webView.url!)
            webView.load(request)
        case forwardButton:
            webView.goForward()
        default:
            break
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        _ = navigationController?.popViewController(animated: true)
    }
}
