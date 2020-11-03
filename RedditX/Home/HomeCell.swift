//
//  HomeCell.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

protocol HomeCellDelegate: class {
    func favoritesDidUnselect(atIndex index: Int)
}

class HomeCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return "HomeCell"
    }
    
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subredditLabel: UILabel!
    @IBOutlet private var favoriteImageView: UIImageView!
    
    weak var delegate: HomeCellDelegate!
    private var index: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
        subredditLabel.text = ""
        thumbnailImageView.layer.cornerRadius = 5.0
        thumbnailImageView.clipsToBounds = true
        favoriteImageView.isHidden = true
    }
    
    func configure(with post: Reddit, atIndex index: Int) {
        self.index = index
        titleLabel.text = post.title
        subredditLabel.text = post.subreddit
        thumbnailImageView.fetchImage(thumbnailURL: post.thumbnailURL)
        favoriteImageView.isHidden = post.isFavorite ? false : true
        
        let backgroundColor = post.isFavorite ? UIColor.yellow : UIColor.white
        self.contentView.backgroundColor = backgroundColor
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.favoritesDidUnselect(atIndex: index)
    }
}
