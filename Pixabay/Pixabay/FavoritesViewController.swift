//
//  FavouritesViewController.swift
//  Pixabay
//
//  Created by Kurnmanbay Ayan on 4/18/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var favs: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        favs = UserDefaults.standard.array(forKey: "favs") as? [String] ?? []
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: pointInTable)!
        favs = favs.filter { $0 != favs[indexPath.item] }
        UserDefaults.standard.set(favs, forKey: "favs")
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 2 - 2, height: self.view.frame.height / 4 - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favs.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.favouriteImageView.sd_setImage(with: URL(string: favs[indexPath.item]), completed: nil)
        return cell
    }
}

