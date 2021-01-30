//
//  DetailRouter.swift
//  RedditClient
//
//  Created by Вячеслав on 27.01.2021.
//

import UIKit

protocol DetailRouterDelegate: class {
    func showZoom(image: UIImage)
}

final class DetailRouter {
    private weak var delegate: DetailRouterDelegate?
    
    init(coordinator: DetailRouterDelegate) {
        self.delegate = coordinator
    }
    
    func build(redditPost: RedditEntity) -> DetailViewController {
        let viewController = DetailViewController.storyboardViewController() as DetailViewController
        viewController.router = self
        viewController.redditPost = redditPost
        return viewController
    }
    
    func showZoom(image: UIImage) {
        delegate?.showZoom(image: image)
    }
}

