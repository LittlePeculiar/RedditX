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
    var favoriteImage: UIImage? { get }
    
    func isFavoriteDidChangeClosure(callback: @escaping (Bool) -> Void)
    func toggleFavorite()
}

class PostDetailVM: PostDetailVMContract {
    
    // MARK: Properties
    var reddit: Reddit
    var redditURL: URL? { return reddit.redditURL }
    
    private var isFavoriteDidChange: ((Bool) -> Void)?
    
    public var title: String {
        return "SubReddit"
    }
    
    public var alertTitle: String {
        return "Error loading Web View"
    }
    var alertMessage: String {
        return "You will be returned to Home View"
    }
    
    var favoriteImage: UIImage? {
        return reddit.isFavorite ? UIImage(named: "isFavorite") :UIImage(named: "addFavorite")
    }
    
    func isFavoriteDidChangeClosure(callback: @escaping (Bool) -> Void) -> Void {
        isFavoriteDidChange = callback
    }
    
    func toggleFavorite() {
        reddit.isFavorite = !reddit.isFavorite
        isFavoriteDidChange?(reddit.isFavorite)
    }
    
    // MARK: Init
    init(reddit: Reddit) {
        self.reddit = reddit
    }
}

