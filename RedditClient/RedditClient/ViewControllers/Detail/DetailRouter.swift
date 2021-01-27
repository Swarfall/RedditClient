//
//  DetailRouter.swift
//  RedditClient
//
//  Created by Вячеслав on 27.01.2021.
//

import Foundation

final class DetailRouter {
    
    func build() -> DetailViewController {
        let viewController = DetailViewController.storyboardViewController() as DetailViewController
        
        return viewController
    }
}
