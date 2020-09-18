//
//  HomeVM.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

protocol HomeVMContract {
    var redditPosts: [Reddit] { get set }
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void
}

class HomeVM: HomeVMContract {
    
    // MARK: Properties
    
    public var redditPosts: [Reddit] = [] {
        didSet {
            redditPostsDidChange?()
        }
    }
    
    private var redditPostsDidChange: (() -> Void)?
    
    func redditPostDidChangeClosure(callback: @escaping () -> Void) -> Void {
        redditPostsDidChange = callback
    }

    // MARK: Init
    
    init(api: APIContract) {
        api.fetchRedditPosts(subreddit: "") { (results) in
            switch results {
            case .failure(_):
                print("An error occured while fetching top reddit posts.")
            case .success(let posts):
                self.redditPosts = posts
            }
        }
    }
    
}

