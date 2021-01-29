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
    let children: [RedditChlidrenData]
}

struct RedditChlidrenData: Decodable {
    let data: RedditChildrenData
}

struct RedditChildrenData: Decodable {
    let title: String
    let thumbnailURL: String
    let author: String
    let commentsCount: Int
    let preview: RedditChildrenDataPreview
    let createdUTC: Double
    
    enum CodingKeys: String, CodingKey {
        case title, preview
        case thumbnailURL = "thumbnail"
        case author = "author_fullname"
        case commentsCount = "num_comments"
        case createdUTC = "created_utc"
    }
}

struct RedditChildrenDataPreview: Decodable {
    let images: [RedditChildrenDataPreviewImages]
}

struct RedditChildrenDataPreviewImages: Decodable {
    let source: RedditChildrenDataPreviewImagesSource
}

struct RedditChildrenDataPreviewImagesSource: Decodable {
    let url: String
}
