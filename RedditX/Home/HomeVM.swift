//
//  HomeVM.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

enum SearchType {
    case post
    case recent
}

protocol HomeVMContract {
    var redditPosts: [Reddit] { get set }
    var redditRecent: [String] { get set }
    var searchType: SearchType { get set }
    var searchString: String { get set }
    var title: String { get }
    var alertLoadTitle: String { get }
    var alertLoadMessage: String { get }
    var isLoading: Bool { get }
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void
    func redditRecentDidChangeClosure(callback: @escaping () -> Void) -> Void
    
    func fetch(subreddit: String, loadMore: Bool)
    func setFavorite(_ isFavorite: Bool, atIndex index: Int)
}

class HomeVM: HomeVMContract {
    
    // MARK: Properties
    
    public var redditPosts: [Reddit] = [] {
        didSet {
            redditPostsDidChange?()
        }
    }
    
    public var redditRecent: [String] = [] {
        didSet {
            redditRecentDidChange?()
        }
    }
    
    public var searchType: SearchType = .post {
        didSet {
            var search = ""
            if searchType == .recent {
                guard !searchString.isEmpty else { return }
                search = searchString
            }
            fetch(subreddit: search, loadMore: false)
        }
    }
    
    public var title: String {
        return "Reddit"
    }
    
    public var alertLoadTitle: String {
        return "Error loading Reddit Posts"
    }
    var alertLoadMessage: String {
        return "Unable to retrieve Reddit Posts.\nPlease check your input or internet connection and try again."
    }
    
    
    public var searchString: String = ""
    public var isLoading: Bool = false
    
    private var redditPostsDidChange: (() -> Void)?
    private var redditRecentDidChange: (() -> Void)?
    private var api: APIContract
    private var after: String = ""
    
    // MARK: Methods
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditPostsDidChange = callback
    }
    
    func redditRecentDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditRecentDidChange = callback
    }
    
    func fetch(subreddit sub: String, loadMore: Bool) {
        isLoading = true

        // build the url
        let postURLString = sub.isEmpty ? APIUrls.postURL : "/r/\(sub)" + APIUrls.postURL
        let afterURLString = loadMore ? APIUrls.afterURL + after : ""
        let fullURLString = APIUrls.baseURL + postURLString + afterURLString

        print(fullURLString)

        api.fetch(forModel: Children.self, urlString: fullURLString) { [weak self](results) in
            switch results {
            case .failure(_):
                print("An error occured while fetching reddit posts.")
                self?.redditPosts.removeAll()
                self?.isLoading = false
            case .success(let result):
                if loadMore {
                    self?.redditPosts.append(contentsOf: result.children)
                } else {
                    self?.redditPosts = result.children
                }
                
                self?.after = result.after
                self?.isLoading = false
                
                // save the searchString if results
                guard !result.children.isEmpty else { return }
                guard self?.searchType == .recent else { return }
                guard let search = self?.searchString, !search.isEmpty else { return }
                self?.updateRecent(searchString: search)
            }
        }
    }
    
    private func updateRecent(searchString: String) {
        // list by most recent
        if !redditRecent.contains(searchString) {
            redditRecent.insert(searchString, at: 0)
        }
        
        // limit list to 5
        if redditRecent.count > 5 {
            redditRecent.removeLast()
        }
    }
    
    public func setFavorite(_ isFavorite: Bool, atIndex index: Int) {
        var post = redditPosts[index]
        post.setFavorite(isFavorite: isFavorite)
        redditPosts[index] = post
    }
    
    
    // MARK: Init
    
    init(api: APIContract) {
        self.api = api
        fetch(subreddit: "", loadMore: false)
    }
    
}

