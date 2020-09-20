//
//  PostDetailVM.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

protocol PostDetailVMContract {
    var redditURL: URL? { get }
    var title: String { get }
    var alertTitle: String { get }
    var alertMessage: String { get }
}

class PostDetailVM: PostDetailVMContract {
    
    // MARK: Properties
    let reddit: Reddit
    var redditURL: URL? { return reddit.redditURL }
    
    public var title: String {
        return "SubReddit"
    }
    
    public var alertTitle: String {
        return "Error loading Web View"
    }
    var alertMessage: String {
        return "You will be returned to Home View"
    }
    
    // MARK: Init
    init(reddit: Reddit) {
        self.reddit = reddit
    }
}

