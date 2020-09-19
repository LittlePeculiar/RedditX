//
//  HomeVC.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: Properties
    fileprivate var viewModel: HomeVMContract
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var postButton: UIButton!
    @IBOutlet private var recentButton: UIButton!
    @IBOutlet private var underLine: UIView!
    
    var activityView = UIActivityIndicatorView(style: .large)
    
    
    // MARK: Init
    init(viewModel: HomeVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup components
        setupUI()

        // start the activity indicator for data loading at start up
        activityView.startAnimating()
        
        // closure called when ever data changes
        viewModel.redditPostDidChangeClosure {[weak self] in
            DispatchQueue.main.async {
                self?.textField.resignFirstResponder()
                self?.tableView.reloadData()
                self?.activityView.stopAnimating()
            }
        }
    }
    
    // MARK: Helper methods
    
    @objc func loadPosts() {
        activityView.startAnimating()
        viewModel.searchType = .post
        moveUnderline()
        clearSearchText()
    }
    
    func loadRecents() {
        textField.resignFirstResponder()
        activityView.startAnimating()
        viewModel.searchType = .recent
        moveUnderline()
    }
    
    func moveUnderline() {
        let postButtonX = postButton.center.x
        let postButtonY = postButton.frame.height + 10
        let recentButtonX = recentButton.center.x
        let recentButtonY = recentButton.frame.height + 10
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            var center: CGPoint = CGPoint.zero
            if self?.viewModel.searchType == .post {
                center = CGPoint(x: postButtonX, y: postButtonY)
            } else {
                center = CGPoint(x: recentButtonX, y: recentButtonY)
            }
            self?.underLine.center = center
        }
    }
    
    func clearSearchText() {
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    func setupUI() {
        self.title = viewModel.title
        
        let refresh = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(loadPosts))
        navigationItem.rightBarButtonItems = [refresh]
        
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: HomeCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HomeCell.reuseIdentifier)

        // make row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    // MARK: Actions
    
    @IBAction func postButtonTapped(_ sender: Any) {
        loadPosts()
    }
    
    @IBAction func recentButtonTapped(_ sender: Any) {
        if !viewModel.redditRecent.isEmpty {
            loadRecents()
        }
    }
}

// MARK: TableView Methods
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.redditPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifier, for: indexPath) as? HomeCell,
            indexPath.row < viewModel.redditPosts.count
        else { return UITableViewCell() }
        
        let post = viewModel.redditPosts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = viewModel.redditPosts[indexPath.row]
        let detailVC = PostDetailVC(viewModel: PostDetailVM(reddit: post))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: TableView Methods
extension HomeVC: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // reset
        clearSearchText()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        viewModel.searchString = text
        loadRecents()
        return true
    }
}

