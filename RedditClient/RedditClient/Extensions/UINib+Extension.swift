//
//  UINib+Extension.swift
//  RedditClient
//
//  Created by Вячеслав on 30.01.2021.
//

import UIKit

protocol IndentifierDescribe {
    static var identifier: String { get }
}

extension IndentifierDescribe {
    static var identifier: String { return .init(describing: self) }
}

protocol Nibable: IndentifierDescribe {
    static var nib: UINib? { get }
}

extension Nibable {
    static var nib: UINib? {
        let identifier = self.identifier
        guard Bundle.main.path(forResource: identifier, ofType: "nib") != nil else {
            return nil
        }
        return UINib(nibName: identifier, bundle: nil)
    }
}

class NibView: UIView, Nibable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    private func setupNib() {
        backgroundColor = UIColor.clear
        guard let view = loadNib() else { return }
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        setupUI()
    }
    
    private func loadNib() -> UIView? {
        guard let nib = Self.nib else { return nil }
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
        
    }

    func setupUI() {}
}

