//
//  DetailViewController.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

protocol DetailViewControllerProtocol: class {
    func differenceInHours(utc date: Double) -> String
    func saveToGallery(image: UIImage)
    func showAlert(title: String, message: String?)
}

final class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var backDropDownView: UIView!
    @IBOutlet weak var dropDownTapView: UIView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet var actionButtons: [UIButton]! {
        didSet {
            actionButtons.forEach {
                $0.isHidden = isOpenDropDown
            }
        }
    }
    
    // MARK: - Public property
    var router: DetailRouter!
    var redditPost: RedditEntity?
    
    // MARK: - Private property
    private lazy var tap = UITapGestureRecognizer()
    private var isOpenDropDown = false
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Actions
    @IBAction func didTapSaveImage(_ sender: Any) {
        if avatarImageView.image != nil {
            saveToGallery(image: avatarImageView.image ?? UIImage())
        } else {
            
        }
    }
}

// MARK: - Private
private extension DetailViewController {
    
    func setupView() {
        guard let reddit = redditPost else { return }
        
        if reddit.imageURLString != nil {
            avatarImageView.loadImageUsingCache(withUrl: reddit.imageURLString ?? "")
        } else {
            avatarImageView.image = UIImage(named: "default_image")
        }
        
        authorLabel.text = reddit.author
        titleLabel.text = reddit.title
        commentsLabel.text = "Comments: \(reddit.commentsCount ?? 0)"
        hoursLabel.text = differenceInHours(utc: reddit.createdUTC ?? 0)
        
        setupTapGesture()
        
        backDropDownView.layer.cornerRadius = backDropDownView.frame.width / 2
        backDropDownView.clipsToBounds = true
    }
    
    func setupTapGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        dropDownTapView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        isOpenDropDown = !isOpenDropDown
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.actionButtons.forEach {
                $0.isHidden = self.isOpenDropDown
            }
            
            if self.isOpenDropDown {
                self.dropDownImageView.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                self.dropDownImageView.transform = .identity
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Ups..😔", message: error.localizedDescription)
        } else {
            showAlert(title: "Success🥳", message: nil)
        }
    }
}

// MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {
    
    func differenceInHours(utc date: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: date)
        let hours = Calendar.current.component(.hour, from: date as Date)
        return "\(hours)h ago"
    }
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}
