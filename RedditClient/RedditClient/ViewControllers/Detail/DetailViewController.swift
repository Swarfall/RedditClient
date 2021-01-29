//
//  DetailViewController.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

final class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    // MARK: - Public property
    var router: DetailRouter!
    var redditPost: RedditEntity?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Private
private extension DetailViewController {
    func setupView() {
        guard let reddit = redditPost else { return }
        
        avatarImageView.loadImageUsingCache(withUrl: reddit.imageURLString ?? "")
        authorLabel.text = reddit.author
        titleLabel.text = reddit.title
        commentsLabel.text = "Comments: \(reddit.commentsCount ?? 0)"
        hoursLabel.text = differenceInHours(utc: reddit.createdUTC ?? 0)
    }
    
    func differenceInHours(utc date: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: date)
        let hours = Calendar.current.component(.hour, from: date as Date)
        return "\(hours)h ago"
    }
}
