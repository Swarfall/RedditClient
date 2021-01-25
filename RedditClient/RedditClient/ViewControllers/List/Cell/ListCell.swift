//
//  ListCell.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

class ListCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

}

// MARK: -  Private
private extension ListCell {
    func setupView() {
        avatarImageView.layer.cornerRadius = 8
    }
}
