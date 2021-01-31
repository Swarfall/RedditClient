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
    func showAlert(title: String, message: String)
    func showZoom()
    func showPopUp(isShow: Bool)
}

final class DetailViewController: UIViewController {
    
    private enum Constants {
        enum PopUp {
            static let y: Double = -80
            static let height: CGFloat = 80
            static let width: Double = 280
            static let animationTime: Double = 0.3
            static let translationX: CGFloat = 0
            static let showTime: Double = 3
            static let sideIndent: Double = 30
            static let sideTop: CGFloat = 20
            static let delayRemove: Double = 1
        }
    }
    
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
    private var popUpView: PopUpView!
    
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
            showAlert(title: "Ups..😔", message: "Don't save image😭")
        }
    }
    
    @IBAction func didTapShowZoom(_ sender: Any) {
        showZoom()
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
    
    func setupPopUpView() {
        
        popUpView = PopUpView(frame: CGRect(x: Double(view.frame.width / 2) - Constants.PopUp.width / 2,
                                            y: Constants.PopUp.y,
                                            width:Constants.PopUp.width,
                                            height: Double(Constants.PopUp.height)))
        
        view.addSubview(popUpView!)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Ups..😔", message: error.localizedDescription)
        } else {
            showPopUp(isShow: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.PopUp.showTime) { [weak self] in
                self?.showPopUp(isShow: false)
            }
        }
    }
    
    func hidePopUp() {
        popUpView?.removeFromSuperview()
    }
}

// MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {
    
    func showPopUp(isShow: Bool) {
        if popUpView == nil ||
            popUpView != nil && !view.subviews.contains(popUpView) {
            setupPopUpView()
        }
        
        UIView.animate(withDuration: Constants.PopUp.animationTime) { [weak self] in
            guard let self = self else { return }
            
            if isShow {
                self.popUpView?.transform = CGAffineTransform(translationX: Constants.PopUp.translationX,
                                                              y: self.view.safeAreaInsets.top + Constants.PopUp.height + Constants.PopUp.sideTop)
            } else {
                self.popUpView?.transform = .identity
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.PopUp.delayRemove) { [weak self] in
                    self?.hidePopUp()
                }
            }
        } completion: { [weak self] _ in
            if !isShow {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.PopUp.animationTime) {
                    self?.hidePopUp()
                }
            }
        }
    }
    
    func showZoom() {
        if let image = avatarImageView.image {
            router.showZoom(image: image)
        } else {
            showAlert(title: "Ups..😔", message: "No image")
        }
    }
    
    func differenceInHours(utc date: Double) -> String {
        let date = NSDate(timeIntervalSince1970: date)
        let hours = Calendar.current.component(.hour, from: date as Date)
        return "\(hours)h ago"
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}
