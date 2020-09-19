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
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void
    func fetchRedditPosts(subreddit: String)
}

class HomeVM: HomeVMContract {
    
    // MARK: Properties
    
    public var redditPosts: [Reddit] = [] {
        didSet {
            redditPostsDidChange?()
        }
    }
    
    public var searchType: SearchType = .post {
        didSet {
            if searchType == .recent {
                guard searchString.isEmpty == false else { return }
                fetchRedditPosts(subreddit: searchString)
                if !redditRecent.contains(searchString) {
                    redditRecent.append(searchString)
                }
            } else {
                fetchRedditPosts(subreddit: "")
            }
        }
    }
    
    public var title: String {
        return "Reddit"
    }
    
    public var redditRecent: [String] = []
    public var searchString: String = "" 
    
    private var redditPostsDidChange: (() -> Void)?
    private var api: APIContract
    
    // MARK: Methods
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditPostsDidChange = callback
    }
    
    func fetchRedditPosts(subreddit sub: String = "") {
        api.fetchRedditPosts(subreddit: sub) { (results) in
            switch results {
            case .failure(_):
                print("An error occured while fetching top reddit posts.")
            case .success(let posts):
                self.redditPosts = posts
            }
        }
    }
    
    
    // MARK: Init
    
    init(api: APIContract) {
        self.api = api
        fetchRedditPosts(subreddit: "")
    }
    
}

