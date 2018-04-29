//
//  ViewController.swift
//  Eggs Toss
//
//  Created by Kurnmanbay Ayan on 3/8/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var levels = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var level = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gameSegue", sender: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(levels[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = "\(levels[row])"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 20.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        level = levels[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameVC = segue.destination as? GameViewController {
            gameVC.level = self.level
        }
    }
    
}

