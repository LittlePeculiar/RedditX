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
    @IBOutlet weak var underlineCenterConstraint: NSLayoutConstraint!
    
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
        
        self.title = viewModel.title
        
        let refresh = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshPosts(subreddit:)))
        navigationItem.rightBarButtonItems = [refresh]
        
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: HomeCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HomeCell.reuseIdentifier)

        // make row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75

        // add weak self to avoid retain cycle
        viewModel.redditPostDidChangeClosure {[weak self] in
            self?.isEditing = false
            self?.tableView.reloadData()
        }
    }
    
    func moveUnderline() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            if let posX = self?.viewModel.searchType == .post ? self?.postButton.center.x : self?.recentButton.center.x {
                self?.underlineCenterConstraint.constant = posX
            }
        }
    }
    
    // MARK: Actions
    
    @objc func refreshPosts(subreddit sub: String = "") {
        viewModel.fetchRedditPosts(subreddit: sub)
        textField.resignFirstResponder()
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        viewModel.searchType = .post
        moveUnderline()
    }
    
    @IBAction func recentButtonTapped(_ sender: Any) {
        viewModel.searchType = .recent
        moveUnderline()
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
        textField.text = ""
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        refreshPosts(subreddit: text)
        return true
    }
}

