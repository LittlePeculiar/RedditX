//
//  Reddit.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

struct RedditContainer: Decodable {
    let posts: [Reddit]
    
    enum CodingKeys: String, CodingKey {
        case posts = "something"
    }
}

struct Reddit: Decodable {

}
