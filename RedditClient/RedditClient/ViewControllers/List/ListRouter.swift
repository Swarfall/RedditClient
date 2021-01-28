//
//  ListRouter.swift
//  RedditClient
//
//  Created by Вячеслав on 27.01.2021.
//

import Foundation

protocol ListRouterDelegate: class {
    func showDetail()
}

final class ListRouter {
    private weak var delegate: ListRouterDelegate?
    
    init(coordinator: ListRouterDelegate) {
        self.delegate = coordinator
    }
    
    func build() -> ListViewController {
        let viewController = ListViewController.storyboardViewController() as ListViewController
        viewController.router = self
        return viewController
    }
    
    func showDetail() {
        delegate?.showDetail()
    }
}
