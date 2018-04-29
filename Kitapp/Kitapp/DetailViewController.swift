//
//  DetailViewController.swift
//  Kitapp
//
//  Created by Kurnmanbay Ayan on 4/8/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    var book: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        bookTitleLabel.text = book[0]
        bookDescriptionLabel.text = book[1]
        bookImageView.sd_setImage(with: URL(string: book[2]))
        var authors = "Authors: "
        for index in 3...book.count - 1 {
            authors += (index == book.count - 1 ? "\(book[index]) " : "\(book[index]), ")
        }
        bookAuthorsLabel.text = authors
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
