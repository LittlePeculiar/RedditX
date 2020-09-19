//
//  GMImageView.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

extension UIImageView {
    
    func fetchImage(URL url: URL) {
        guard let placeholder = UIImage(named: "redditIcon") else {
            self.image = nil
            return
        }
        guard let imageData = try? Data(contentsOf: url) else {
            self.image = placeholder
            return
        }
        let image = UIImage(data: imageData)
        self.image = image
    }

}
