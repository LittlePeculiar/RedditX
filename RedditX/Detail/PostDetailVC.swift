//
//  PostDetailVC.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit
import WebKit


class PostDetailVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Properties
    private let viewModel: PostDetailVMContract
    var activityView = UIActivityIndicatorView(style: .large)


    // MARK: Init
    init(viewModel: PostDetailVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        setupUI()
    }

    // MARK: methods

    private func setupUI() {
        self.title = viewModel.title
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        if let url = viewModel.redditURL {
            activityView.startAnimating()
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        } else {
            let alert = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                self?.goBack()
            }))
            self.present(alert, animated: true)
        }
    }
    
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PostDetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
}
