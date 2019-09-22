//
//  APIService.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


final class APIService {
    static let instance = APIService()
    private let baseURL = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!

    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }


    // Use singleton
    private init () { }

    
    // MARK: API

    func get<T: Codable>(completion: @escaping (Result<T, APIError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noResponse))
                }
                return
            }

            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error: error!)))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.jsonDecodingError(error: error)))
                }
            }
        }

        task.resume()
    }
}
