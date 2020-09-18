//
//  PostDetailVM.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

protocol PostDetailVMContract {
    var subreddit: String { get }
    var title: String { get }
    var permalink: String { get }
    var thumbnail: String { get }
}

class PostDetailVM: PostDetailVMContract {
    
    // MARK: Properties
    let reddit: Reddit
    
    var subreddit: String { return reddit.subreddit }
    var title: String { return reddit.title }
    var permalink: String { return reddit.permalink }
    var thumbnail: String { return reddit.thumbnail }
    
    var authorProfilePhoto: UIImage? {
        guard
            let imageUrl = reddit.thumbnailImageUrl,
            let imageData = try? Data(contentsOf: imageUrl)
            else { return nil }
        
        return UIImage(data: imageData)
    }

    
    // MARK: Init
    init(reddit: Reddit) {
        self.reddit = reddit
    }
    
}

