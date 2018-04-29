//
//  GameViewController.swift
//  Eggs Toss
//
//  Created by Kurnmanbay Ayan on 3/8/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var brokenEggImageView: UIImageView!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet var eggLife: [UIImageView]!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var eggPosition = 0
    var basketPosition = 1
    
    var timer = Timer()
    var level = 0
    var lives = 5
    var score = 0
    var speed = 4
    var isBonus = false
    
    @IBAction func changePositionButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            basketPosition = 0
            basketImageView.frame.origin.x = 26
        case 1:
            basketPosition = 1
            basketImageView.frame.origin.x = 119
        default:
            basketPosition = 2
            basketImageView.frame.origin.x = 214
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        buttonBackgroundView.isHidden = false
        gameOverView.isHidden = true
        brokenEggImageView.isHidden = true
        basketImageView.frame.origin.x = 119
        basketPosition = 1
        speed = 4
        lives = 5
        score = 0
        for egg in eggLife {
            egg.image = UIImage(named: "egg")
        }
        throwEgg()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketImageView.frame.origin.y -= CGFloat(level * 15)
        throwEgg()
    }
    
    func getInitialPosition() {
        eggPosition = Int(arc4random_uniform(3))
        switch eggPosition {
        case 0:
            eggImageView.frame.origin.x = 81
        case 1:
            eggImageView.frame.origin.x = 174
        default:
            eggImageView.frame.origin.x = 268
        }
        eggImageView.frame.origin.y = 0
    }
    
    func generateBonusEgg() { // silver
        let eggType = Int(arc4random_uniform(UInt32(5 + lives)))
        if eggType == 0 {
            eggImageView.image = UIImage(named: "egg-bonus")
            isBonus = true
        }
        else {
            eggImageView.image = UIImage(named: "egg-flying")
            isBonus = false
        }
    }
    
    func throwEgg() {
        if lives > 0 {
            getInitialPosition()
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(changePosition), userInfo: nil, repeats: true)
        }
        else {
            gameOver()
        }
    }
    
    @objc func changePosition() {
        eggImageView.frame.origin.y += CGFloat(speed)
        checkEgg()
    }
    
    func checkEgg() {
        let frameY = eggImageView.frame.origin.y
        if frameY >= CGFloat(380 - (level * 15)) && frameY <= CGFloat(430 - (level * 15)) && basketPosition == eggPosition {
            if (isBonus && lives < 5) {
                lives += 1
                eggLife[lives - 1].image = UIImage(named: "egg")
            }
            speed = score % 5 == 0 ? speed + 2 : speed // bronze
            score += 1
            timer.invalidate()
            generateBonusEgg()
            throwEgg()
        }
        if frameY >= 500 {
            updateLife()
            brokenEggImageView.frame.origin.x = eggImageView.frame.origin.x - 20
            brokenEggImageView.isHidden = false
            lives -= 1
            timer.invalidate()
            generateBonusEgg()
            throwEgg()
        }
    }
    
    func gameOver() {
        gameOverView.isHidden = false
        scoreLabel.text = "\(score)"
        buttonBackgroundView.isHidden = true
    }
    
    func updateLife() {
        eggLife[lives - 1].image = UIImage(named: "egg-broken")
    }
    
}
