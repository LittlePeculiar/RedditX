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
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let imageData = data else {
                    self.image = placeholder
                    return
                }
                let image = UIImage(data: imageData)
                self.image = image
            }
        }.resume()
    }

}
