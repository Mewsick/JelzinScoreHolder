//
//  FirstViewController.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct player {
    var name: String
    var score: Int
    var wonGames: Int
    var turn: Int
}

class FirstViewController: UIViewController, CallbackDelegate{
   
    var players: [player] = []
    var backupScenarios: [[player]] = []
    var currentTurn: Int = 1
    var gameTurns: Int = 0
    var isPlaying: Bool = true
    let ref = Database.database().reference()
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var addPlayer: UIButton!
    @IBOutlet var touchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload\(players)")
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.touchView.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
   @IBAction func pressForReadyToPlay(_ sender: Any) {
        if players.count != 0 {
            performSegue(withIdentifier: "secondSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController{
            let vc = segue.destination as? ViewController
            vc?.players = players
            vc?.delegate = self
            vc?.isPlaying = isPlaying
            vc?.gameTurns = gameTurns
            vc?.backupScenarios = backupScenarios
            vc?.currentTurn = currentTurn
       }
    }
    
    @IBAction func addPlayerPressed(_ sender: Any) {
        if inputField.text != ""{
            let text: String = inputField.text?.uppercased() ?? "player\(players.count)"
            addPlayer.isEnabled = false
            var pscore: Int = 0
            ref.child("Players/" + text + "/score").observeSingleEvent(of: .value) { (snapshot) in
                let playerScore = snapshot.value as? String
                if playerScore != nil{
                    pscore = Int(playerScore!)!
                }
            }
            
            var pWon: Int = 0
            ref.child("Players/" + text + "/wonGames").observeSingleEvent(of: .value) { (snapshot) in
                let playerWon = snapshot.value as? String
                //print(playerStats!)
                if playerWon != nil{
                    pWon = Int(playerWon!)!
                    
                }
            }
            
            print(text)
            print(pscore)
            run(after: 700) {
                self.players.append(player(name: text, score: pscore, wonGames: pWon, turn: self.gameTurns))
                print(self.players)
                self.inputField.text = ""
                self.view.endEditing(true)
                self.addPlayer.isEnabled = true

            }
        }
    }

    func run(after mSeconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .milliseconds(mSeconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func setData(p: [player], b: Bool, gt: Int, bs: [[player]], c: Int){
        players = p
        print("players set: \(players)")
        isPlaying = b
        gameTurns = gt
        backupScenarios = bs
        currentTurn = c
    }
    
    func setPlayers(p: [player]) {
        players = p
        print("players set: \(players)")
    }
}
