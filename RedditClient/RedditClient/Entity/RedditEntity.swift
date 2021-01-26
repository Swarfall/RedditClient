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
    init(model: RedditModel? = nil, index: Int? = nil) {
        guard let model = model,
              let index = index else { return }

        let children = model.data.children[index]
        
        title = children.title
        thumbnailURL = children.thumbnailURL
        author = children.author
        commentsCount = children.commentsCount
        destURL = children.destURL
        createdUTC = children.createdUTC
    }
}
