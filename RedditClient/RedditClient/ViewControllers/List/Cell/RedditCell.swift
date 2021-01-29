//
//  RedditCell.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

final class RedditCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backAvatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var backContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - PublicMethod
    func update(entity: RedditEntity) {
        
        if entity.thumbnailURL == nil || entity.thumbnailURL?.contains("https://") == false  {
            backAvatarView.isHidden = true
        } else {
            avatarImageView.loadImageUsingCache(withUrl: entity.thumbnailURL ?? "")
        }
        
        titleLabel.text = entity.title
        commentsCountLabel.text = "Comments: \(entity.commentsCount ?? 0)"
        authorLabel.text = "Author: \(entity.author ?? "no info")"
        hoursAgoLabel.text = differenceInHours(utc: entity.createdUTC ?? 0)
    }

}

// MARK: -  Private
private extension RedditCell {
    
    func differenceInHours(utc date: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: date)
        let hours = Calendar.current.component(.hour, from: date as Date)
        return "\(hours)h ago"
    }
    
    func setupView() {
        
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true

        avatarImageView.layer.cornerRadius = 8
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {

        getData(from: url) { data, response, error in
            guard let data = data,
                  error == nil else { return }

            DispatchQueue.main.async() { [weak self] in
                self?.avatarImageView.image = UIImage(data: data)
            }
        }
    }
}
