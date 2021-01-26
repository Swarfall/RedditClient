//
//  RedditModel.swift
//  RedditClient
//
//  Created by Вячеслав on 26.01.2021.
//

import Foundation

struct RedditModel: Decodable {
    let data: RedditData
    
    struct RedditData: Decodable {
        let children: [RedditChildren]
        
        struct RedditChildren: Decodable {
            let title: String
            let thumbnailURL: String
            let author: String
            let commentsCount: Int
            let destURL: String
            let createdUTC: Double
            
            enum CodingKeys: String, CodingKey {
                case title
                case thumbnailURL = "thumbnail"
                case author = "name"
                case commentsCount = "num_comments"
                case destURL = "url_overridden_by_dest"
                case createdUTC = "created_utc"
            }
        }
    }
}
