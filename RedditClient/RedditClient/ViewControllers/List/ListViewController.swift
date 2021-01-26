//
//  ListViewController.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

protocol ListViewControllerProtocol: class {
    func reloadData()
    func showOverlay()
    func hideOverlay()
    func fetchReddit()
}

final class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Private properties
    private lazy var refreshControl: UIRefreshControl = {
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshing(sender:)), for: .valueChanged)
        return refresh
    }()
    
    private lazy var overlayView = UIView()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private var apiManager: APIManager!
    private var redditList: [RedditEntity]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

// MARK: - Private
private extension ListViewController {
    func setupView() {
        setupCell()
    }
    
    func setupCell() {
        collectionView.register(UINib(nibName: String(describing: RedditCell.self), bundle: nil),
                                forCellWithReuseIdentifier: String(describing: RedditCell.self))
    }
    
    @objc func refreshing(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    
}

// MARK: - CollectionView
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIWindow.isLandscape {
            return CGSize(width: 0, height: 0) // FIXME: - Mock data
        } else {
            return CGSize(width: 0, height: 0) // FIXME: - Mock data
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return redditList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RedditCell.self), for: indexPath) as? RedditCell else { return  UICollectionViewCell() }
        cell.update(entity: redditList[indexPath.row])
        return cell
    }
}

// MARK: - ListViewControllerProtocol
extension ListViewController: ListViewControllerProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showOverlay() {
        overlayView.frame = CGRect(x: view.frame.width,
                                   y: view.frame.height,
                                   width: view.frame.width,
                                   height: view.frame.height)
        overlayView.center = view.center
        overlayView.backgroundColor = .lightGray
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.alpha = 0.7
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2,
                                           y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    func hideOverlay() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    
    func fetchReddit() {
        showOverlay()
        apiManager.fetchReddit(limit: "10") { [weak self] reddit in
            guard let self = self else { return }
            
        } fail: { [weak self] (errorString) in
            guard let self = self else { return }
            
        }

    }
}
