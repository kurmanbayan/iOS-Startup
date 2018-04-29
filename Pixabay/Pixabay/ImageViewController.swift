//
//  ImageViewController.swift
//  Pixabay
//
//  Created by Kurnmanbay Ayan on 4/14/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imgUrl = ""
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var fullImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.delegate = self
        
        let url = URL(string: self.imgUrl)!
        fullImageView.sd_setImage(with: url, completed: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // Bronze: I don't know the reason, but UIActivityViewController works after several taps
    @IBAction func shareBtnPressed(_ sender: UIButton) {
       
        let activityViewController = UIActivityViewController(activityItems: [ imgUrl ], applicationActivities: [])
        
        self.present(activityViewController, animated: true)
    
    }
}
