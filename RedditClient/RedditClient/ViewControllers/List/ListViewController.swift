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
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    private lazy var refreshControl: UIRefreshControl = {
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshing(sender:)), for: .valueChanged)
        return refresh
    }()
    
    private lazy var overlayView = UIView()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private var apiManager = APIManager()
    private var redditList: [RedditEntity] = []
    var router: ListRouter!
    
    // MARK: - LifeCycle
    //    init(router: ListRouter) {
    //        self.router = router
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchReddit()
    }
    
}

// MARK: - Private
private extension ListViewController {
    func setupView() {
        setupCell()
    }
    
    func setupCell() {
        tableView.register(UINib(nibName: String(describing: RedditCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: RedditCell.self))
    }
    
    @objc func refreshing(sender: UIRefreshControl) {
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
}

// MARK: - ListViewControllerProtocol
extension ListViewController: ListViewControllerProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
    
    
    func fetchReddit() {
        showOverlay()
        apiManager.fetchReddit(limit: "25") { [weak self] redditData in
            guard let self = self else { return }
            let children = redditData.data.children
            
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
