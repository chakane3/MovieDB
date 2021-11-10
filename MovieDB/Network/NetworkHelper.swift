//
//  NetworkHelper.swift
//  MovieDB
//
//  Created by Chakane Shegog on 11/9/21.
//

import Foundation

/*
    We will use a "network helper" to allow our apps to "talk" to the internet.
    We use a completion handler which takes in a string that represents a url and a closure of type: (Result<Data, NetworkError) -> Void.
*/

class NetworkHelper {
    static let shared = NetworkHelper()
    private var session: URLSession
    
    // initialize this class by creating a url session
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(with request: URLRequest, completion: @escaping (Result<Data, AppError>) -> ()) {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // check for errors
            
            // network error
            if let error = error {
                completion(.failure(.networkClientError(error)))
            }
            
            // no response error
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            // no data was returned
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // make sure we get a 200 response
            switch urlResponse.statusCode {
            case 200...299: break
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}


