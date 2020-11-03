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
    
    func fetchRedditPosts(subreddit: String, loadMore: Bool)
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
            fetchRedditPosts(subreddit: search, loadMore: false)
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
    
    func fetchRedditPosts(subreddit sub: String, loadMore: Bool) {
        isLoading = true
        let param = loadMore ? after : ""
        api.fetchRedditPosts(subreddit: sub, after: param) { [weak self](results, after) in
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
                
                self?.after = after
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
        fetchRedditPosts(subreddit: "", loadMore: false)
    }
    
}

