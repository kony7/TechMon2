//
//  BattleViewController.swift
//  TechMon
//
//  Created by SeinaKonishi on 2022/02/20.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!

    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var playerHP = 100
    var playerMP = 100
    var enemyHP = 100
    var enemyMP = 100
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = "マグロ"
        playerImageView.image = UIImage(named: "tyutoro")
        playerHPLabel.text =  "\(playerHP) / 100"
        playerMPLabel.text =  "\(playerMP) / 20"
        
        enemyNameLabel.text = "たまご"
        playerImageView.image = UIImage(named: "tamago")
        enemyHPLabel.text =  "\(enemyHP) / 200"
        enemyMPLabel.text =  "\(enemyMP) / 35"
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "sushikuine")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame(){
        
        playerHP += 1
        if playerMP >= 20{
            isPlayerAttackAvailable = true
            playerMP = 20
        }else{
            isPlayerAttackAvailable = false
        }
        
        enemyMP += 1
        if enemyMP > 35{
            enemyAttack()
            enemyMP = 0
        }
        
        playerMPLabel.text =  "\(playerMP) / 20"
        enemyMPLabel.text =  "\(enemyMP) / 35"
        
    }
    
    func enemyAttack(){
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        
        playerHPLabel.text =  "\(playerHP) / 100"
        
        if playerHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
        
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin{
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "WIN!!!!!"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "LOSS!!!!!!!!"
        }
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func attackAction(){
        if isPlayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            enemyHP -= 30
            playerMP = 0
            
            enemyHPLabel.text =  "\(enemyHP) / 200"
            playerMPLabel.text =  "\(playerMP) / 20"
            
            if enemyHP <= 0{
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
