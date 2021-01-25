//
//  ListViewController.swift
//  RedditClient
//
//  Created by Вячеслав on 25.01.2021.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var redditList: [RedditEntity]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCell()
    }
    
}

// MARK: - Private
private extension ListViewController {
    func setupCell() {
        
    }
}

// MARK: - CollectionView
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return redditList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
