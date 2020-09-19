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
}

protocol APIContract {
    func fetchRedditPosts(subreddit: String, completion: @escaping (Swift.Result<[Reddit], FetchError>) -> Void)
}

class API: APIContract {
    
    let session = URLSession.shared
    
    func fetchRedditPosts(subreddit sub: String, completion: @escaping (Result<[Reddit], FetchError>) -> Void) {
        let postURLString = sub.isEmpty ? Constants.postURL : "/r/\(sub)" + Constants.postURL
        guard let url = URL(string: Constants.baseURL + postURLString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.responseFailure))
                return
            }
            guard let postData = data else {
                completion(.failure(.noData))
                return
            }
            guard let container = try? JSONDecoder().decode(Children.self, from: postData) else {
                    completion(.failure(.serializationError))
                    return
            }
            completion(.success(container.children))
            
        }.resume()
    }

}
