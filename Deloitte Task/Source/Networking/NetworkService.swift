//
//  NetworkService.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import UIKit

struct NetworkService {
    fileprivate static let baseURL = "https://itunes.apple.com"
    fileprivate static let searchPath = "/search"
    
    static private func get(path: String, baseURL: String = baseURL,
                    queryItems: [URLQueryItem]? = nil, parameters: [String: String]? = nil,
                    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            let err = URLParsingError.invalidURL(String(describing: urlComponents?.description))
            completionHandler(nil, nil, err)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    
    
    static func getAlbums(searchString: String, completionHandler: @escaping (Result<[AlbumModel]>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "entity", value: "album"),
            URLQueryItem(name: "limit", value: "200"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "term", value: searchString)
        ]
        
        get(path: searchPath, queryItems: queryItems) { (data, _, error) in
            if let err = error {
                completionHandler(.failure(err))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let feed = try decoder.decode(Feed<AlbumModel>.self, from: data)
                    completionHandler(.success(feed.results))
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    static func downloadImage(imageUrl: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completionHandler(nil)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){ (data, _, _) in
            if let data = data {
                completionHandler(UIImage(data: data))
                return
            }
        }
        task.resume()
    }
    
}
