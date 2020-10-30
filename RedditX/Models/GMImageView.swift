//
//  GMImageView.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

extension UIImageView {
    
    func fetchImage(thumbnailURL: URL?) {
        
        // make sure placeholder image is installed
        
        guard let placeholder = UIImage(named: "redditIcon") else {
            self.image = nil
            return
        }
        self.image = placeholder
        
        guard let url = thumbnailURL else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let imageData = data else { return }
                self.image = UIImage(data: imageData)
            }
        }.resume()
    }

}
