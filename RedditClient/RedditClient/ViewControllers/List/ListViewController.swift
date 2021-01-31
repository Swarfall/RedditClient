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
    func showDetail(redditPost: RedditEntity)
    func showAlert(title: String, message: String)
}

final class ListViewController: UIViewController {
    
    private enum Constants {
        static let defaultLimit: Int = 30
        static let addToLimit: Int = 20
        
        enum OverlayView {
            static let cornerRadius: CGFloat = 10
            static let alpha: CGFloat = 0.7
            static let x: CGFloat = 0
            static let y: CGFloat = 0
            static let width: CGFloat = 100
            static let height: CGFloat = 100
        }
        
        enum Activity {
            static let height: CGFloat = 44
        }
    }
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
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
    
    // MARK: - Public property
    var router: ListRouter!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        showOverlay()
        fetchReddit(with: limit)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        overlayView.frame.size = size
        activityIndicator.center = overlayView.center
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
    
    @objc func refreshingReload(sender: UIRefreshControl) {
        limit = Constants.addToLimit
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
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.tableFooterView?.frame.width ?? 0, height: Constants.Activity.height)
            activityIndicator.startAnimating()
            tableView.tableFooterView = activityIndicator
            tableView.tableFooterView?.isHidden = false
            
            limit += Constants.addToLimit
            fetchReddit(with: limit)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(redditPost: redditList[indexPath.row])
    }
}

// MARK: - ListViewControllerProtocol
extension ListViewController: ListViewControllerProtocol {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDetail(redditPost: RedditEntity) {
        router.showDetail(redditPost: redditPost)
    }
    
    
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
        overlayView.layer.cornerRadius = Constants.OverlayView.cornerRadius
        overlayView.alpha = Constants.OverlayView.alpha
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: Constants.OverlayView.x,
                                                                  y: Constants.OverlayView.y,
                                                                  width: Constants.OverlayView.width,
                                                                  height: Constants.OverlayView.height))
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    func hideOverlay() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
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
            
            self.showAlert(title: "Ups..😔", message: errorString)
            self.hideOverlay()
        }
    }
}
