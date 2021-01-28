//
//  APIManager.swift
//  RedditClient
//
//  Created by Вячеслав on 26.01.2021.
//

import Foundation

protocol APIManagerProtocol: class {
    func fetchReddit(limit: String, success: @escaping (RedditModel) -> Void, fail: @escaping(String) -> Void)
}

final class APIManager {
    let baseURL = "https://www.reddit.com/top/.json?"
}

extension APIManager: APIManagerProtocol {
    func fetchReddit(limit: String, success: @escaping (RedditModel) -> Void, fail: @escaping (String) -> Void) {
        
        guard let url = URL(string: "\(baseURL)limit=\(limit)") else { return }
        print("url: - \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, responce, error) in
            guard let data = data else { return }
            print("data: - \(data)")
            do {
                let reddit = try JSONDecoder().decode(RedditModel.self, from: data)
                success(reddit)
            } catch let error {
                fail(error.localizedDescription)
            }
        }.resume()
    }
}
