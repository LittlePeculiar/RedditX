//
//  API.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

enum FetchError: Error {
    case invalidUrl
    case responseFailure
    case serializationError
}

enum Constants {
    static let searchTweetsUrlString = "https://api.twitter.com/1.1/search/tweets.json"
    static let token = "AAAAAAAAAAAAAAAAAAAAANLi3wAAAAAAIugIfddmQcEt4aetIH%2BE42nNk4E%3Dh5ZxkNhQP9cAigpbfm87oK6BTzkRj9OlZo6BR9GQcGdgWbbgfP"
}

protocol APIContract {
    func fetchMedicalTweets(completion: @escaping (Swift.Result<[Tweet], FetchError>) -> Void)
}

class API: NSObject {

}
