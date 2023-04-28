//
//  UserRegisterOnWebViewViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 06/04/23.
//

import UIKit
import WebKit

class UserRegisterOnWebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupWebView()
        setNavigationBarTitle()
    }
    
    private func setupWebView(){
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        guard let url = URL(string: "https://career.phntechnology.com/")else{return}
        webView.load(URLRequest(url: url))
        self.stopAnimating()
    }
      func stopAnimating(){
          let seconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.activityIndicator.stopAnimating()
            self.webView.allowsBackForwardNavigationGestures = true
        }
    }
    private func setNavigationBarTitle(){
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40))
        label.textColor = UIColor.black
        label.text = "Registration".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = label
    }
}


