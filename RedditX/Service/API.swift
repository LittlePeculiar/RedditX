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
    case noData
    case serializationError
}

enum Constants {
    static let baseURL = "https://www.reddit.com"
    static let postURL = "/.json"
    static let afterURL = "?limit=20&after="
}

protocol APIContract {
    func fetchRedditPosts(subreddit: String, after: String, completion: @escaping (Swift.Result<[Reddit], FetchError>, String) -> Void)
}

class API: APIContract {
    
    let session = URLSession.shared
    
    func fetchRedditPosts(subreddit sub: String, after: String, completion: @escaping (Result<[Reddit], FetchError>, String) -> Void) {
        let postURLString = sub.isEmpty ? Constants.postURL : "/r/\(sub)" + Constants.postURL
        let afterURLString = after.isEmpty ? after : Constants.afterURL + after
        let fullURLString = Constants.baseURL + postURLString + afterURLString
        
        guard let url = URL(string: fullURLString) else {
            completion(.failure(.invalidUrl), "")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.responseFailure), "")
                return
            }
            guard let postData = data else {
                completion(.failure(.noData), "")
                return
            }
            guard let container = try? JSONDecoder().decode(Children.self, from: postData) else {
                    completion(.failure(.serializationError), "")
                    return
            }
            completion(.success(container.children), container.after)
            
        }.resume()
    }

}
