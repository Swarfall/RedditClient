//
//  ZoomViewController.swift
//  RedditClient
//
//  Created by Вячеслав on 30.01.2021.
//

import UIKit

final class ZoomViewController: UIViewController {
    
    // MARK: - Public properties
    var router: ZoomRouter!
    var zoomImage: UIImage!
    
    // MARK: - Private property
    private var imageScrollView: ImageScrollView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Private
private extension ZoomViewController {
    
    func setupView() {
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        
        self.imageScrollView.set(image: zoomImage)
    }
    
    func setupImageScrollView() {
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
