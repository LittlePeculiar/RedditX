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
    var redditRecent: [Reddit] { get set }
    var searchType: SearchType { get set }
    var searchString: String { get set }
    var title: String { get }
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void
    func fetchRedditPosts(subreddit: String)
    func fetchImage(URL url: URL) -> UIImage?
}

class HomeVM: HomeVMContract {
    
    // MARK: Properties
    
    public var redditPosts: [Reddit] = [] {
        didSet {
            redditPostsDidChange?()
        }
    }
    
    public var redditRecent: [Reddit] = [] {
        didSet {
            redditPostsDidChange?()
        }
    }
    
    public var searchString: String = "" {
        didSet {
            fetchRedditPosts(subreddit: searchString)
        }
    }
    
    public var searchType: SearchType = .post {
        didSet {
            let search = searchType == .post ? "" : searchString
            fetchRedditPosts(subreddit: search)
        }
    }
    
    public var title: String {
        return "Reddit"
    }
    
    private var redditPostsDidChange: (() -> Void)?
    private var api: APIContract
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditPostsDidChange = callback
    }
    
    func fetchRedditPosts(subreddit sub: String) {
        api.fetchRedditPosts(subreddit: "") { (results) in
            switch results {
            case .failure(_):
                print("An error occured while fetching top reddit posts.")
            case .success(let posts):
                self.redditPosts = posts
            }
        }
        
    }
    
    func fetchImage(URL url: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: imageData)
    }
    
    // MARK: Init
    
    init(api: APIContract) {
        self.api = api
        fetchRedditPosts(subreddit: "")
    }
    
}

