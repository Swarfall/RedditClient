//
//  ZoomRouter.swift
//  RedditClient
//
//  Created by Вячеслав on 30.01.2021.
//

import UIKit

final class ZoomRouter {
    
    func build(image: UIImage) -> ZoomViewController {
        let viewController = ZoomViewController.storyboardViewController() as ZoomViewController
        viewController.router = self
        viewController.zoomImage = image
        return viewController
    }
}
