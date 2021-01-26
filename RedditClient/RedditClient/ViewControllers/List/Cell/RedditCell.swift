//
//  RedditCell.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

class RedditCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var avatarBackView: UIView!
    @IBOutlet weak var contentBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func update(entity: RedditEntity) {
        
    }

}

// MARK: -  Private
private extension RedditCell {
    func setupView() {
        
        backView.layer.cornerRadius = 8
        
        avatarImageView.layer.cornerRadius = 8
    }
}
