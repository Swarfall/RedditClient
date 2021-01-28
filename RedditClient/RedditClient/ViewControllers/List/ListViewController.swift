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
    func fetchReddit(with limit: Int)
}

final class ListViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    private lazy var downloadRefreshControl: UIRefreshControl = {
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshingDownload(sender:)), for: .valueChanged)
        return refresh
    }()
    
    private lazy var reloadRefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshingReload(sender:)), for: .valueChanged)
        refresh.tintColor = .blue
        refresh.attributedTitle = NSAttributedString(string: "Reload...")
        return refresh
    }()
    
    private lazy var overlayView = UIView()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private var apiManager = APIManager()
    private var redditList: [RedditEntity] = []
    private var limit: Int = 30
    private var defaultLimit: Int = 30
    private let addToLimit: Int = 20
    
    // MARK: - Public property
    var router: ListRouter!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        showOverlay()
        fetchReddit(with: limit)
    }
}

// MARK: - Private
private extension ListViewController {
    func setupView() {
        
        setupCell()
        tableView.refreshControl = reloadRefreshControl
    }
    
    func setupCell() {
        tableView.register(UINib(nibName: String(describing: RedditCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: RedditCell.self))
    }
    
    @objc func refreshingDownload(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    @objc func refreshingReload(sender: UIRefreshControl) {
        limit = defaultLimit
        fetchReddit(with: limit)
        sender.endRefreshing()
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource
    extension ListViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return redditList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedditCell.self), for: indexPath) as? RedditCell else { return UITableViewCell() }
            cell.update(entity: redditList[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == limit - 1 {
                
                activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.tableFooterView?.frame.width ?? 0, height: 44)
                activityIndicator.startAnimating()
                tableView.tableFooterView = activityIndicator
                tableView.tableFooterView?.isHidden = false
                
                limit += addToLimit
                fetchReddit(with: limit)
            }
        }
    }
    
    // MARK: - ListViewControllerProtocol
    extension ListViewController: ListViewControllerProtocol {
        
        func reloadData() {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
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
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.overlayView.removeFromSuperview()
            }
        }
        
        
        func fetchReddit(with limit: Int) {
            
            apiManager.fetchReddit(limit: "\(limit)") { [weak self] redditData in
                guard let self = self else { return }
                let children = redditData.data.children
                self.redditList.removeAll()
                for reddit in children {
                    self.redditList.append(RedditEntity(model: reddit.data))
                }
                
                self.reloadData()
                self.hideOverlay()
                
            } fail: { [weak self] errorString in
                guard let self = self else { return }
                debugPrint("fetchReddit error: - \(errorString)")
                self.hideOverlay()
            }
        }
    }
