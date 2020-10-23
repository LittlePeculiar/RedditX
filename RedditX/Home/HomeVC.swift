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
    @IBOutlet private var spinner: Spinner!
    
    private var menuCenter: MenuCenter? = nil
    private var hasRecent: Bool = false {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.recentButton.isEnabled = self?.hasRecent == true
                let color: UIColor = self?.hasRecent == true ? .black : .lightGray
                self?.recentButton.setTitleColor(color, for: .normal)
            }
        }
    }
    
    
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
        
        // closure called when ever data changes
        viewModel.redditPostDidChangeClosure {[weak self] in
            DispatchQueue.main.async {
                self?.textField.resignFirstResponder()
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
                self?.validate()
            }
        }
        viewModel.redditRecentDidChangeClosure {[weak self] in
            self?.hasRecent = self?.viewModel.redditRecent.isEmpty == false
        }
        
        // check for data after attempting to fetch
        if viewModel.isLoading == false {
            validate()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && viewModel.isLoading == false {
            viewModel.fetchRedditPosts(subreddit: viewModel.searchString, loadMore: true)
        }
    }
    
    // MARK: Helper methods
    
    @objc private func handleRotate() {
        // rebuild the menu position and load
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        guard viewModel.searchType == .recent else { return }
        menuCenter = nil
        refresh()
    }
    
    @objc private func loadPosts() {
        spinner.startAnimating()
        viewModel.searchType = .post
        moveUnderline()
        clearSearchText()
    }
    
    private func loadRecents() {
        textField.resignFirstResponder()
        spinner.startAnimating()
        viewModel.searchType = .recent
        moveUnderline()
    }
    
    @objc private func moveUnderline() {
        // setup the struct if first time here
        if self.menuCenter == nil {
            let startCenter = CGPoint(x: postButton.center.x, y: postButton.frame.height + 10)
            let endCenter = CGPoint(x: recentButton.center.x, y: recentButton.frame.height + 10)
            self.menuCenter = MenuCenter(startCenter: startCenter, endCenter: endCenter)
        }
        
        // animate the underline bar
        guard let menuCenter = self.menuCenter else { return }
        let searchType = self.viewModel.searchType
        let center: CGPoint = searchType == .post ? menuCenter.startCenter : menuCenter.endCenter
        
        UIView.animate(withDuration: 1.0) { [weak self] in
            DispatchQueue.main.async {
                self?.underLine.center = center
            }
        }
    }
    
    private func validate() {
        // for whatever reason no posts received, show alert
        if viewModel.redditPosts.isEmpty == true {
            spinner.stopAnimating()
            showAlert(withTitle: viewModel.alertLoadTitle, andMessage: viewModel.alertLoadMessage)
        }
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func clearSearchText() {
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    private func setupUI() {
        self.title = viewModel.title
        
        let refresh = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(loadPosts))
        navigationItem.rightBarButtonItems = [refresh]
        
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: HomeCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HomeCell.reuseIdentifier)

        // make row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        
        // disable the recent button until we have something
        hasRecent = false
    }
    
    func refresh() {
        self.view.layoutIfNeeded()
        if viewModel.searchType == .post {
            loadPosts()
        } else {
            loadRecents()
        }
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

