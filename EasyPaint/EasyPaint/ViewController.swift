//
//  ViewController.swift
//  EasyPaint
//
//  Created by Kurnmanbay Ayan on 4/21/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var brushSizeLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var brushSize: CGFloat = 10.0
    var brushColor = UIColor.black
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var colors = ["black", "red", "orange", "blue", "brown", "cyan"]
    var uicolors = [UIColor.black, UIColor.red, UIColor.orange, UIColor.blue, UIColor.brown, UIColor.cyan]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.darkGray
        pickerView.alpha = 0.7
        pickerView.layer.cornerRadius = 8
        
        self.brushSizeLabel.text = "\(Int(self.brushSize))"
    }


    @IBAction func minusButtonPressed(_ sender: UIButton) {
        if self.brushSize > 0 {
            self.brushSize -= 1
            self.brushSizeLabel.text = "\(Int(self.brushSize))"
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        self.brushSize += 1
        self.brushSizeLabel.text = "\(Int(self.brushSize))"
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        self.mainImageView.image = nil
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(brushColor.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        self.tempImageView.alpha = 1.0
        
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.swiped = false
        if let touch = touches.first {
            self.lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            self.drawLineFrom(fromPoint: self.lastPoint, toPoint: currentPoint)
            self.lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            self.drawLineFrom(fromPoint: self.lastPoint, toPoint: self.lastPoint)
        }
        UIGraphicsBeginImageContext(self.mainImageView.frame.size)
        self.mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        self.tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        
        self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.tempImageView.image = nil
    }
    
    @IBAction func rubberButtonPressed(_ sender: UIButton) {
        brushColor = UIColor.white
        // just changed the order of temp image view and main image view
    }
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        pickerView.isHidden = false
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        shareButton.setTitleColor(UIColor.white, for: .normal)
        
        let size = CGSize(width: view.frame.width, height: view.frame.height - 60)
        UIGraphicsBeginImageContext(size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        shareButton.setTitleColor(UIColor.black, for: .normal)
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = colors[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor: uicolors[row]])
    
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorButton.setTitleColor(uicolors[row], for: .normal)
        brushColor = uicolors[row]
        pickerView.isHidden = true
    }

}

