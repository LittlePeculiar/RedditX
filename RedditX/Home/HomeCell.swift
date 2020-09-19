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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
        subredditLabel.text = ""
        thumbnailImageView.layer.cornerRadius = 5.0
        thumbnailImageView.clipsToBounds = true

    }
    
    func configure(with post: Reddit) {
        titleLabel.text = post.title
        subredditLabel.text = post.subreddit
        
        if let url = post.thumbnailImageUrl {
            thumbnailImageView.fetchImage(URL: url)
        } else {
            thumbnailImageView.image = nil
        }
        
    }
    
}
