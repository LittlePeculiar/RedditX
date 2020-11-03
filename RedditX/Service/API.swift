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

protocol APIContract {
    func fetch<T: Decodable>(forModel model: T.Type, urlString: String, completion: @escaping (Swift.Result<T, FetchError>) -> Void)
}

class API: APIContract {
    
    let session = URLSession.shared
    
    func fetch<T: Decodable>(forModel model: T.Type, urlString: String, completion: @escaping (Swift.Result<T, FetchError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
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
            do {
                let container = try JSONDecoder().decode(T.self, from: postData)
                completion(.success(container))
            } catch {
                print(error)
                completion(.failure(.serializationError))
                return
            }
            
        }.resume()
    }

}
