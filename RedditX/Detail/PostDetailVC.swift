//
//  PostDetailVC.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

class PostDetailVC: UIViewController {
    
    // MARK: Properties
    private let viewModel: PostDetailVMContract

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
        
        setupUI()
    }

    // MARK: methods

    private func setupUI() {
        
        updateUI()
    }

    private func updateUI() {
        
    }

}
