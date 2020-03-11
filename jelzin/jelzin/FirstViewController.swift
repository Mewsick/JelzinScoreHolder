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
    
    var listOfPlayers: [player] = []
    var isPlaying: Bool = true
    var gameTurns: Int = 0
    let ref = Database.database().reference()
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var addPlayer: UIButton!
    @IBOutlet var touchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload\(listOfPlayers)")
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.touchView.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
   @IBAction func pressForReadyToPlay(_ sender: Any) {
        if listOfPlayers.count != 0 {
            performSegue(withIdentifier: "secondSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController{
            let vc = segue.destination as? ViewController
            vc?.players = listOfPlayers
            vc?.delegate = self
            vc?.isPlaying = isPlaying
            vc?.gameTurns = gameTurns
       }
    }
    
    @IBAction func addPlayerPressed(_ sender: Any) {
        if inputField.text != ""{
            let text: String = inputField.text?.uppercased() ?? "player\(listOfPlayers.count)"
            
            var pscore: Int = 0
            ref.child("Players/" + text + "/score").observeSingleEvent(of: .value) { (snapshot) in
                let playerScore = snapshot.value as? String
                //print(playerStats!)
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
            run(after: 1) {
                self.listOfPlayers.append(player(name: text, score: pscore, wonGames: pWon, turn: self.gameTurns - 1))
                print(self.listOfPlayers)
                self.inputField.text = ""
                self.view.endEditing(true)
            }
        }
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func setPlayers(players: [player]) {
        listOfPlayers = players
        print("players set: \(listOfPlayers)")
    }
    
    func setIsPlaying(b: Bool) {
           isPlaying = b
       }
    
    func setGameTurns(gt: Int) {
           gameTurns = gt
       }
}
