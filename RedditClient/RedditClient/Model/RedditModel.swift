//
//  RedditModel.swift
//  RedditClient
//
//  Created by Вячеслав on 26.01.2021.
//

import Foundation

struct RedditModel: Decodable {
    let data: RedditData
}

struct RedditData: Decodable {
    let children: [RedditChlidren]
}

struct RedditChlidren: Decodable {
    let data: RedditChildrenData
}

struct RedditChildrenData: Decodable {
    let title: String
    let thumbnailURL: String
    let author: String
    let commentsCount: Int
    let awardings: [RedditChildrenDataAwardings]?
    let createdUTC: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailURL = "thumbnail"
        case author = "author_fullname"
        case commentsCount = "num_comments"
        case awardings = "all_awardings"
        case createdUTC = "created_utc"
    }
}

struct RedditChildrenDataAwardings: Decodable {
    let imageURL: String?
    
        enum CodingKeys: String, CodingKey {
            case imageURL = "icon_url"
        }
}
