//
//  DetailRouter.swift
//  RedditClient
//
//  Created by Вячеслав on 27.01.2021.
//

import Foundation

final class DetailRouter {
    
    func build(redditPost: RedditEntity) -> DetailViewController {
        let viewController = DetailViewController.storyboardViewController() as DetailViewController
        viewController.router = self
        viewController.redditPost = redditPost
        return viewController
    }
}
