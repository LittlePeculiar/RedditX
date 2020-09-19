//
//  GMImageView.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

extension UIImageView {
    
    func fetchImage(URL url: URL) {
        guard let imageData = try? Data(contentsOf: url) else {
            self.image = nil
            return
        }
        let image = UIImage(data: imageData)
        self.image = image
    }

}
