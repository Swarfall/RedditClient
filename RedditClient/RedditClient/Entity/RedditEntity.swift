//
//  RedditEntity.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import Foundation

struct RedditEntity {
    var title: String?
    var thumbnailURL: String?
    var author: String?
    var commentsCount: Int?
    var destURL: String?
    var createdUTC: Double?
}

// MARK: - Init for convert from RedditModel
extension RedditEntity {
    init(model: RedditChildren? = nil) {
        guard let model = model else { return }

        title = model.title
//        thumbnailURL = model.thumbnailURL
//        author = model.author
//        commentsCount = model.commentsCount
//        destURL = model.destURL
//        createdUTC = model.createdUTC
    }
}
