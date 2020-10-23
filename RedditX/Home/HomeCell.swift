//
//  HomeCell.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

class HomeCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return "HomeCell"
    }
    
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subredditLabel: UILabel!
    @IBOutlet private var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
        subredditLabel.text = ""
        thumbnailImageView.layer.cornerRadius = 5.0
        thumbnailImageView.clipsToBounds = true
        favoriteImageView.isHidden = true
    }
    
    func configure(with post: Reddit) {
        titleLabel.text = post.title
        subredditLabel.text = post.subreddit
        thumbnailImageView.fetchImage(thumbnailURL: post.thumbnailURL)
        favoriteImageView.isHidden = post.isFavorite ? false : true
        
        let backgroundColor = post.isFavorite ? UIColor.yellow : UIColor.white
        self.contentView.backgroundColor = backgroundColor
    }
    
}
