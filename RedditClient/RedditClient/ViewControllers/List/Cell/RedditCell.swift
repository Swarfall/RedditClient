//
//  RedditCell.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

class RedditCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backAvatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var backContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func update(entity: RedditEntity) {
        
        if entity.thumbnailURL == nil {
            backAvatarView.isHidden = true
        }
        
        titleLabel.text = entity.title
        commentsCountLabel.text = "Comments: \(entity.commentsCount ?? 0)"
        authorLabel.text = entity.author
        
    }

}

// MARK: -  Private
private extension RedditCell {
    func setupView() {
        
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true

        avatarImageView.layer.cornerRadius = 8
    }
}
