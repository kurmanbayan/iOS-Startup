//
//  ViewController.swift
//  Pixabay
//
//  Created by Kurnmanbay Ayan on 4/13/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var imagesButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [Image] = []
    var videos: [Video] = []
    
    var isSearchImages = true
    var currentQuery = ""
    
    let blueColor = UIColor.init(red: 122/255, green: 137/255, blue: 1, alpha: 1)
    
    @IBAction func onImagesButtonClicked(_ sender: UIButton) {
        isSearchImages = true
        imagesButton.backgroundColor = blueColor
        imagesButton.setTitleColor(UIColor.white, for: .normal)
        
        videosButton.backgroundColor = .white
        videosButton.setTitleColor(blueColor, for: .normal)
        
        if currentQuery != "" {
            getData(query: currentQuery)
        }
    }
    @IBAction func onVideosButtonClicked(_ sender: UIButton) {
        isSearchImages = false
        videosButton.backgroundColor = blueColor
        videosButton.setTitleColor(UIColor.white, for: .normal)
        
        imagesButton.backgroundColor = .white
        imagesButton.setTitleColor(blueColor, for: .normal)
        
        if currentQuery != "" {
            getData(query: currentQuery)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // : TO CLEAN USERDEFAULTS
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }

        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupButtons()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    func setupButtons() {
        imagesButton.layer.borderColor = blueColor.cgColor
        imagesButton.layer.borderWidth = 1
        
        videosButton.layer.borderColor = blueColor.cgColor
        videosButton.layer.borderWidth = 1
    }
    
    func getData(query: String) {
        self.images = []
        self.videos = []
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    
        if isSearchImages {
            searchImages(query: query)
        }
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: pointInTable)!
        let cell = collectionView.cellForItem(at: indexPath) as! CustomImageCollectionViewCell

        var favs = UserDefaults.standard.array(forKey: "favs") as? [String] ?? []
        if sender.currentImage == UIImage(named: "favorite") {
            favs = favs.filter { $0 !=  images[indexPath.item].webformatURL }
            cell.favButton.setImage(UIImage(named: "star"), for: .normal)
        }
        else {
            favs.append(images[indexPath.item].webformatURL)
            cell.favButton.setImage(UIImage(named: "favorite"), for: .normal)
        }
        print(favs)
        UserDefaults.standard.set(favs, forKey: "favs")
    }
    
    
    func searchImages(query: String) {
        let url = URL(string: "https://pixabay.com/api/?key=8690497-859815612b5dbd82cea4a5b09&q=\(query)&image_type=photo")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                let json = JSON(data!)
                if let hits = json["hits"].arrayObject {
                    for hit in hits {
                        let hit = JSON(hit)
                        let previewURL = hit["previewURL"].string!
                        let webFormat = hit["webformatURL"].string!
                        let largeImageURL = hit["largeImageURL"].string!
                        let tags = hit["tags"].string!
                        let image = Image(previewURL: previewURL, webformatURL: webFormat, tags: tags, largeImageURL: largeImageURL)
                        self.images.append(image)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imgVC = segue.destination as? ImageViewController {
            imgVC.imgUrl = sender as! String
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 2, height: self.view.frame.height / 4)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchImages {
            return self.images.count
        }
        return self.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CustomImageCollectionViewCell
        var url: URL
        if isSearchImages {
            url = URL(string: self.images[indexPath.item].webformatURL)!
        }
        else {
            url = URL(string: self.videos[indexPath.item].previewURL)!
        }
        let favs = UserDefaults.standard.array(forKey: "favs") as? [String] ?? []
        var isFound = false
        for fav in favs {
            let imgUrl = self.images[indexPath.item].webformatURL
            if fav.substring(from: 0, to: fav.count - 15) == imgUrl.substring(from: 0, to: fav.count - 15) {
                isFound = true
                break;
            }
        }
        
        if isFound {
            cell.favButton.setImage(UIImage(named: "favorite"), for: .normal)
        }
        else {
            cell.favButton.setImage(UIImage(named: "star"), for: .normal)
        }
        cell.previewImageView.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FullImgId", sender: self.images[indexPath.item].largeImageURL)
    }
}

extension ViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        
        let trimmedString = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString != "" {
            self.currentQuery = trimmedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            getData(query: self.currentQuery)
        }
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }
}

