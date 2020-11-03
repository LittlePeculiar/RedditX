//
//  Reddit.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

private struct RedditContainer: Decodable {
    var data: Data
    
    struct Data: Decodable {
        var children: [Reddit]
        var after: String
    }
}

struct Children: Decodable {
    var children: [Reddit]
    var after: String

    init(from decoder: Decoder) throws {
        let container = try RedditContainer(from: decoder)
        children = container.data.children
        after = container.data.after
    }
}

struct Reddit: Decodable {
    var subreddit: String
    var title: String
    var permalink: String
    var thumbnail: String
    var isFavorite: Bool = false
    
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

    public init() {
        subreddit = ""
        title = ""
        permalink = ""
        thumbnail = ""
        isFavorite = false
    }
    
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
    
    var redditURL: URL? {
        return URL(string: APIUrls.baseURL + permalink)
    }
    
    mutating func setFavorite(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}
