applicationWillTerminate//
//  LoginViewController.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 26/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var requestToken: RequestToken?
    var completion: () -> Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: date) {
            
            self.loadingView.startAnimating()
            self.createRequestToken()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func createRequestToken() {
        
        Services.shared.createRequestToken { [weak self] (requestToken, error) in
            guard let weakSelf = self else { return }
            
            if let requestToken = requestToken {
                weakSelf.requestToken = requestToken
                weakSelf.authenticate()
            }
            else {
                
            }
        }
    }
    
    func authenticate() {
        
        if let requestToken = requestToken?.requestToken {
            let urlString = "https://www.themoviedb.org/authenticate/\(requestToken)"
            let request = URLRequest(url: URL(string: urlString)!)
            
            webView.load(request)
        }
    }
    
    func createSession() {
        
        if let requestToken = requestToken?.requestToken {
            
            Services.shared.createSession(requestToken: requestToken) { [weak self] (session, error) in
                guard let weakSelf = self else { return }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.saveContext()
                
                weakSelf.accountDetail()
            }
        }
    }
    
    func accountDetail() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let session = Session.currentSession(in: context),
            let sessionId = session.sessionId {
            
            Services.shared.accountDetail(sessionId: sessionId) {  [weak self] (profile, error) in
                guard let weakSelf = self else { return }
                
                appDelegate.saveContext()
                weakSelf.dismiss(animated: true, completion: {
                    weakSelf.completion()
                })
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WKNavigationDelegate
extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let response = navigationResponse.response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            
            if let callback = headers["authentication-callback"] as? String, !callback.isEmpty {
                
                createSession()
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        webView.alpha = 0.2
        loadingView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.alpha = 1
        loadingView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        webView.alpha = 1
        loadingView.stopAnimating()
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func presentLoginViewController(completion: @escaping () -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "rootLogin") as! UINavigationController
        let viewController = navigationController.viewControllers.first as! LoginViewController
        
        viewController.completion = completion
        
        present(navigationController, animated: true, completion: nil)
    }
}
