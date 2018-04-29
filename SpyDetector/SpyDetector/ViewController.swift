//
//  ViewController.swift
//  SpyDetector
//
//  Created by Kurnmanbay Ayan on 3/14/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftColorLabel: UILabel!
    @IBOutlet weak var rightColorLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
   
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBAction func onNoButtonPressed(_ sender: UIButton) {
        allAnswers += 1
        statusImageView.isHidden = false
        if (leftTitleIndex != rightColorIndex) {
            correctAnswers += 1
            statusImageView.image = UIImage(named: "success")
        }
        else {
            statusImageView.image = UIImage(named: "fail")
        }
        setupViews()
    }
    
    @IBAction func onYesButtonPressed(_ sender: UIButton) {
        allAnswers += 1
        statusImageView.isHidden = false
        if (leftTitleIndex == rightColorIndex) {
            correctAnswers += 1
            statusImageView.image = UIImage(named: "success")
        }
        else {
            statusImageView.image = UIImage(named: "fail")
        }
        setupViews()
    }
    
    var correctAnswers = 0
    var allAnswers = 0
    
    var userName = ""
    var timerCount = 0
    
    var leftColorIndex = 0
    var leftTitleIndex = 0
    
    var rightColorIndex = 0
    var rightTitleIndex = 0
    var timerCountEx = 0
    
    var timer = Timer()
    
    var colors = [UIColor.red, UIColor.blue, UIColor.cyan, UIColor.brown, UIColor.black, UIColor.green, UIColor.orange, UIColor.purple]
    var titles = ["Red", "Blue", "Cyan", "Brown", "Black", "Green", "Orange", "Purple"]
    var results: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        userNameLabel.text = userName
        timerLabel.text = "\(timerCount).00"
        timerCount *= 100
        timerCountEx = timerCount
        
        setupRLViews()
        setupViews()
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerChecker), userInfo: nil, repeats: true)
    }
    
    @objc func timerChecker() {
        if timerCount >= 0 {
            timerLabel.text = String(format: "%02d", timerCount / 100) + "." + String(format: "%02d", timerCount % 100)
            timerCount -= 1
        }
        else {
            results = UserDefaults.standard.array(forKey: "results") as? [[String]] ?? []
            results.append([userName.uppercased(), "\(correctAnswers)", "\(allAnswers)"])
            UserDefaults.standard.set(results, forKey: "results")
            
            statusImageView.isHidden = true
            tableView.reloadData()
            timer.invalidate()
            resultsView.isHidden = false
        }
    }
    
    func setupViews() {
        leftColorIndex = Int(arc4random_uniform(UInt32(colors.count)))
        leftTitleIndex = Int(arc4random_uniform(UInt32(colors.count)))
        
        rightColorIndex = Int(arc4random_uniform(UInt32(colors.count)))
        rightTitleIndex = Int(arc4random_uniform(UInt32(colors.count)))
        
        leftColorLabel.textColor = colors[leftColorIndex]
        leftColorLabel.text = titles[leftTitleIndex]
        
        rightColorLabel.textColor = colors[rightColorIndex]
        rightColorLabel.text = titles[rightTitleIndex]
    }
    
    func setupRLViews() {
        leftView.layer.cornerRadius = 8
        rightView.layer.cornerRadius = 8
        
        leftView.layer.shadowOpacity = 0.5
        leftView.layer.shadowOffset = CGSize(width: 0, height: 2)
        leftView.layer.shadowRadius = 10
        leftView.layer.shadowColor = UIColor.black.cgColor
        
        rightView.layer.shadowOpacity = 0.5
        rightView.layer.shadowOffset = CGSize(width: 0, height: 2)
        rightView.layer.shadowRadius = 10
        rightView.layer.shadowColor = UIColor.black.cgColor
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func onMenuButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPlayAgainButtonPressed(_ sender: UIButton) {
        correctAnswers = 0
        allAnswers = 0
        timerCount = timerCountEx
        startTimer()
        resultsView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainIdentifier", for: indexPath) as! MainTableViewCell
        cell.userNameLabel.text = results[indexPath.row][0]
        cell.timerLabel.text = results[indexPath.row][1] + "/" + results[indexPath.row][2]
        return cell
    }

}

