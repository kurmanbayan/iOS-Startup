//
//  BookTableViewCell.swift
//  Kitapp
//
//  Created by Kurnmanbay Ayan on 4/5/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let firstColor = UIColor.init(red: 248/255, green: 216/255, blue: 18/255, alpha: 1).cgColor
        let secondColor = UIColor.init(red: 239/255, green: 207/255, blue: 10/255, alpha: 1).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bookBackgroundView.bounds
        gradientLayer.colors = [firstColor, secondColor]
        bookBackgroundView.layer.addSublayer(gradientLayer)
    }
    
    @IBOutlet weak var bookBackgroundView: UIView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var bookPagesLabel: UILabel!
    
}
