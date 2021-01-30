//
//  PopUpView.swift
//  RedditClient
//
//  Created by Вячеслав on 30.01.2021.
//

import UIKit

final class PopUpView: NibView {

    @IBOutlet weak var backView: UIView!
    
    override func setupUI() {
        super.setupUI()
        setupView()
    }

}

private extension PopUpView {
    func setupView() {
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true
    }
}
