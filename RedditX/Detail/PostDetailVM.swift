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
}

class PostDetailVM: PostDetailVMContract {
    
    // MARK: Properties
    let reddit: Reddit
    var redditURL: URL? { return reddit.redditURL }
    
    public var title: String {
        return "Details"
    }
    
    // MARK: Init
    init(reddit: Reddit) {
        self.reddit = reddit
    }
}

