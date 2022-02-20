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
    @IBOutlet var playerTPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    
//    var playerHP = 100
//    var playerMP = 100
//    var enemyHP = 100
//    var enemyMP = 100

    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = "マグロ"
        playerImageView.image = UIImage(named: "tyutoro")
//        playerHPLabel.text =  "\(playerHP) / 100"
//        playerMPLabel.text =  "\(playerMP) / 20"
        
        enemyNameLabel.text = "たまご"
        enemyImageView.image = UIImage(named: "tamago")
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
//        enemyHPLabel.text =  "\(enemyHP) / 200"
//        enemyMPLabel.text =  "\(enemyMP) / 35"
        
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
        
        player.currentHP += 1
        if player.currentMP >= 20{
            isPlayerAttackAvailable = true
            player.currentMP = 20
        }else{
            isPlayerAttackAvailable = false
        }
        
        enemy.currentMP += 1
        if enemy.currentMP > 35{
            enemyAttack()
            enemy.currentMP = 0
        }
        updateGame()
        
    }
    
    func enemyAttack(){
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= 20
        
        apdateUI()
        
        jadgeBattle()
        
    }
    
    func apdateUI(){
        
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        
       enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
        
    }
    
    func jadgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
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
            enemy.currentHP -= player.attackPoint
            
            player.currentTP += 10
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            apdateUI()
            jadgeBattle()
//            if enemy.currentHP <= 0{
//                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
//            }
        }
    }
    
    @IBAction func tameruAction(){
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
        }
    }
    
    @IBAction func fireAction(){
        if isPlayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            jadgeBattle()
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
