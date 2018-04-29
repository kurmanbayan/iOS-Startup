//
//  ViewController.swift
//  Kitapp
//
//  Created by Kurnmanbay Ayan on 3/15/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import KRPullLoader

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var bookTableView: UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nothingFoundImageView: UIImageView!
    
    var books = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboard()
        bookTableView.delegate = self
        bookTableView.dataSource = self
        
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        bookTableView.addPullLoadableView(refreshView, type: .loadMore)
        
        bookTableView.allowsSelection = true
        bookTableView.tableFooterView = UIView()
        setupViews()
    }
    
    @IBAction func onSearchButtonPressed(_ sender: UIButton) {
        if (searchTextField.text?.count != 0) {
            performAnimation()
            getBooks(bookTitle: searchTextField.text!, loadMore: false)
        }
    }
    
    var startIndex = 0
    
    func getBooks(bookTitle: String, loadMore: Bool) {
        if loadMore {
            startIndex += 10
        }
        else {
            startIndex = 0
        }
        let stringUrl = "https://www.googleapis.com/books/v1/volumes?q=\(bookTitle.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)&startIndex=\(startIndex)&maxResults=10"
        print(stringUrl)
        
        guard let url = NSURL(string: stringUrl) else {
            return
        }
        
        let urlRequest = URLRequest(url: url as URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let json = JSON(data!)
                if let items = json["items"].arrayObject {
                    if loadMore {
                        self.books += items as! [[String: AnyObject]]
                    }
                    else {
                        self.books = items as! [[String: AnyObject]]
                    }
                    DispatchQueue.main.async {
                        self.nothingFoundImageView.isHidden = true
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.bookTableView.isHidden = true
                        self.nothingFoundImageView.isHidden = false
                    }
                }
                
                DispatchQueue.main.async {
                    self.bookTableView.reloadData()
                }
            }
        }
        task.resume()
    }

    func setupViews() {
        searchTextField.layer.cornerRadius = 8
        searchButton.layer.cornerRadius = 8
        
        searchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        searchTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.book = sender as! [String]
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        textField.layer.shadowRadius = 5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.shadowOpacity = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count != 0) {
            performAnimation()
            getBooks(bookTitle: textField.text!, loadMore: false)
        }
        return true
    }
    func performAnimation() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.75) {
            self.searchTextField.frame.origin.y = 24
            self.bookTableView.isHidden = false
            self.logoImageView.isHidden = true
            self.searchButton.isHidden = true
        }
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        switch state {
        case let .loading(completionHandler):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                self.getBooks(bookTitle: self.searchTextField.text!, loadMore: true)
                self.bookTableView.reloadData()
            }
        default: break
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        if let volumeInfo = self.books[indexPath.row]["volumeInfo"] as? [String: AnyObject] {
            cell.bookTitleLabel.text = volumeInfo["title"] as? String
            cell.bookDescriptionLabel.text = volumeInfo["subtitle"] as? String
            if let pageCount = volumeInfo["pageCount"] as? Int {
                cell.bookPagesLabel.text = "Pages: \(pageCount)"
            }
            else {
                cell.bookPagesLabel.text = "Pages: undefined"
            }
            
            if let imageLinks = volumeInfo["imageLinks"] as? [String: AnyObject] {
                if let thumbnail = imageLinks["thumbnail"] as? String {
                    cell.bookImageView.sd_setImage(with: URL(string: thumbnail))
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedBook: [String] = []
        if let volumeInfo = self.books[indexPath.row]["volumeInfo"] as? [String: AnyObject] {
            selectedBook.append(volumeInfo["title"] as? String ?? "")
            selectedBook.append(volumeInfo["description"] as? String ?? "")
            
            if let imageLinks = volumeInfo["imageLinks"] as? [String: AnyObject] {
                selectedBook.append(imageLinks["thumbnail"] as? String ?? "")
            }
            if let authors = volumeInfo["authors"] as? [String] {
                for author in authors {
                    selectedBook.append(author)
                }
            }
            performSegue(withIdentifier: "showDetail", sender: selectedBook)
        }
    }
}

