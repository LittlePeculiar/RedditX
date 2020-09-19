//
//  Reddit.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

private struct RedditContainer: Decodable {
    struct Data: Decodable {
        var children: [Reddit]
    }

    var data: Data
}

struct Children: Decodable {
    var children: [Reddit]

    init(from decoder: Decoder) throws {
        let rawResponse = try RedditContainer(from: decoder)
        children = rawResponse.data.children
    }
}

struct Reddit: Decodable {
    var subreddit: String
    var title: String
    var permalink: String
    var thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case subreddit
        case title
        case permalink
        case thumbnail
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try mainContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        subreddit = try container.decode(String.self, forKey: .subreddit)
        title = try container.decode(String.self, forKey: .title)
        permalink = try container.decode(String.self, forKey: .permalink)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
    }
    
    var thumbnailImageUrl: URL? {
        return URL(string: thumbnail)
    }
    
    var redditURL: URL? {
        return URL(string: Constants.baseURL + permalink)
    }
}
