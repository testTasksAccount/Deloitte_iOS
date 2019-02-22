//
//  AlbumDetailsVC.swift
//  Deloitte Task
//
//  Created by admin on 22/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import UIKit
import WebKit
class AlbumDetailsVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: AlbumModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.activityIndicator.startAnimating()
        
        guard let url = URL(string: self.model.collectionViewUrl) else {return}
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.activityIndicator.stopAnimating()
    }
    
}
