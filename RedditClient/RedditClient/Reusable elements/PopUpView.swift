//
//  PopUpView.swift
//  RedditClient
//
//  Created by Вячеслав on 30.01.2021.
//

import UIKit

final class PopUpView: NibView {
    
    enum Constant {
        static let cornerRadius: CGFloat = 8
    }

    @IBOutlet weak var backView: UIView!
    
    override func setupUI() {
        super.setupUI()
        setupView()
    }
}

private extension PopUpView {
    func setupView() {
        backView.layer.cornerRadius = Constant.cornerRadius
        backView.clipsToBounds = true
    }
}
