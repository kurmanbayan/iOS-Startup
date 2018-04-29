//
//  StartViewController.swift
//  SpyDetector
//
//  Created by Kurnmanbay Ayan on 3/14/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To Clear the cache of results
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }
    }
    
    @IBAction func onStartButtonPressed(_ sender: UIButton) {
        if !(timerTextField.text?.isEmpty)! && !(timerTextField.text?.isEmpty)! {
            performSegue(withIdentifier: "startSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.userName = nameTextField.text!
            vc.timerCount = Int(timerTextField.text!)!
        }
    }
    
}
