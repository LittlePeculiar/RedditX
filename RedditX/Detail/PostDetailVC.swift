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
    @IBOutlet private var spinner: Spinner!
    
    // MARK: Properties
    private let viewModel: PostDetailVMContract
    private var isFavoriteButton = UIButton()


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
        
        isFavoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        isFavoriteButton.setImage(viewModel.favoriteImage, for: .normal)
        
        let barButton = UIBarButtonItem(customView: isFavoriteButton)
        navigationItem.rightBarButtonItems = [barButton]
        
        if let url = viewModel.redditURL {
            spinner.startAnimating()
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
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavorite()
        isFavoriteButton.setImage(viewModel.favoriteImage, for: .normal)
    }
    
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PostDetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
}
