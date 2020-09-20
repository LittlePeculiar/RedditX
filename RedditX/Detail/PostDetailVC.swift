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
    private var activityView = UIActivityIndicatorView()


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
        
        // todo :: make this a custom view
        let size = UIDevice.current.userInterfaceIdiom == .phone ? 40.0 : 80.0
        activityView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        activityView.center = self.parent?.view.center ?? self.view.center
        activityView.hidesWhenStopped = true
        activityView.style = .whiteLarge
        activityView.color = UIColor.redditOrange()
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
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
