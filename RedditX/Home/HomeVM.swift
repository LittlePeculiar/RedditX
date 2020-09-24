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
    func fetchRedditPosts(subreddit: String)
    
    func redditRecentDidChangeClosure(callback: @escaping () -> Void) -> Void
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
            fetchRedditPosts(subreddit: search)
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
    
    // MARK: Methods
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditPostsDidChange = callback
    }
    
    func redditRecentDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditRecentDidChange = callback
    }
    
    func fetchRedditPosts(subreddit sub: String = "") {
        isLoading = true
        api.fetchRedditPosts(subreddit: sub) { [weak self](results) in
            switch results {
            case .failure(_):
                print("An error occured while fetching reddit posts.")
                self?.redditPosts.removeAll()
                self?.isLoading = false
            case .success(let posts):
                self?.redditPosts = posts
                self?.isLoading = false
                
                // save the searchString if results
                guard !posts.isEmpty else { return }
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
    
    
    // MARK: Init
    
    init(api: APIContract) {
        self.api = api
        fetchRedditPosts(subreddit: "")
    }
    
}

