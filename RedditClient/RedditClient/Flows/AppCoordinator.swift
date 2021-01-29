//
//  AppCoordinator.swift
//  RedditClient
//
//  Created by Вячеслав on 27.01.2021.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigation: UINavigationController
    private var detailVC: DetailViewController?
    
    init(window: UIWindow) {
        self.window = window
        self.navigation = UINavigationController()
        self.window.rootViewController = navigation
    }
    
    func start() {
        let router = ListRouter(coordinator: self)
        let viewController = router.build()
        navigation.setViewControllers([viewController], animated: true)
    }
}

extension AppCoordinator: ListRouterDelegate {
    func showDetail(redditPost: RedditEntity) {
        let router = DetailRouter()
        detailVC = router.build(redditPost: redditPost)

        guard let detailVC = detailVC else { return }
        navigation.pushViewController(detailVC, animated: true)
    }
}
