//
//  ViewController.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol CallbackDelegate: NSObjectProtocol {
    func setData(p: [player], b: Bool, gt: Int, bs: [[player]], c: Int)
}

let screenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: CallbackDelegate?
    var players: [player] = []
    var playerTurns: [player] = []
    var backupScenarios: [[player]] = []
    let ref = Database.database().reference()
    var inputName: String = ""
    var scoreToBeAdded = 0
    var currentTurn: Int = 1
    var gameTurns: Int = 0
    var isPlaying: Bool = true
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var onePlusButton: UIButton!
    @IBOutlet weak var fivePlusButton: UIButton!
    @IBOutlet weak var tenPlusButton: UIButton!
    @IBOutlet weak var oneMinusButton: UIButton!
    @IBOutlet weak var fiveMinusButton: UIButton!
    @IBOutlet weak var resetScoreButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        tableView.dataSource = self
        tableView.delegate = self
        if players.count < 6 {
            tableView.rowHeight = ((screenHeight - 125) * 0.6)/CGFloat(players.count)
        }else{
            tableView.rowHeight = ((screenHeight - 125) * 0.6)/CGFloat(5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = delegate {
            delegate.setData(p: players, b: isPlaying, gt: gameTurns, bs: backupScenarios, c: currentTurn)
            print("ViewWillDisappear\(players)")
        } else {
            print("Delegate is null")
        }
    }
    
    @IBAction func onePlusPressed(_ sender: Any) {
        scoreToBeAdded += 1
        scoreLabel.text = scoreToBeAdded.description
    }
    @IBAction func fivePlusPressed(_ sender: Any) {
        scoreToBeAdded += 5
        scoreLabel.text = scoreToBeAdded.description
    }
    @IBAction func tenPlusPressed(_ sender: Any) {
        scoreToBeAdded += 10
        scoreLabel.text = scoreToBeAdded.description
    }
    @IBAction func oneMinusPressed(_ sender: Any) {
        scoreToBeAdded += -1
        scoreLabel.text = scoreToBeAdded.description
    }
    @IBAction func fiveMinusPressed(_ sender: Any) {
        scoreToBeAdded += -5
        scoreLabel.text = scoreToBeAdded.description
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        if backupScenarios.count > 0{
            if gameTurns != 0{
                gameTurns -= 1
            }else{
                currentTurn -= 1
                gameTurns = players.count
            }
            players = backupScenarios.last!
            backupScenarios.remove(at: (backupScenarios.count - 1))
            scoreLabel.text = "0"
            scoreToBeAdded = 0
            for i in 0..<players.count{
                ref.child("Players/" + players[i].name + "/score").setValue(String(players[i].score))
                ref.child("Players/" + players[i].name + "/wonGames").setValue(String(players[i].wonGames))
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func resetScorePressed(_ sender: Any) {
        if !players.isEmpty{
            backupScenarios.removeAll()
            for i in 0...players.count - 1{
                players[i].score = 0
                players[i].turn = 0
            }
            for i in 0..<players.count{
                ref.child("Players/" + players[i].name + "/score").setValue("0")
            }
            isPlaying = true
            scoreToBeAdded = 0
            gameTurns = 0
            currentTurn = 1
            scoreLabel.text = "0"
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backupScenarios.append(players)
        if scoreToBeAdded != 0 && isPlaying != false{
            if players[indexPath.row].turn < currentTurn{
                players[indexPath.row].score += scoreToBeAdded
                ref.child("Players/" + players[indexPath.row].name + "/score").setValue(players[indexPath.row].score.description)
                scoreToBeAdded = 0
                scoreLabel.text = scoreToBeAdded.description
                players[indexPath.row].turn += 1
                gameTurns += 1
                if gameTurns == players.count{
                    currentTurn += 1
                    gameTurns = 0
                    players = players.sorted(by: { $0.score < $1.score })
                    if players.last!.score > 49{
                        scoreLabel.text = "\(players.first!.name) vann!"
                        isPlaying = false
                        
                        players[0].wonGames += 1
                        ref.child("Players/" + players[indexPath.row].name + "/wonGames").setValue(players[indexPath.row].wonGames.description)
                        for i in 0..<players.count{
                            ref.child("Players/" + players[i].name + "/score").setValue("0")
                        }
                    }
                }
                print(players[indexPath.row].turn, currentTurn)
                tableView.reloadData()
            }
            else{
                scoreLabel.text = "spelaren \(players[indexPath.row].name) har redan fått poäng denna omgång"
                scoreToBeAdded = 0
            }
            print(players)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewCell
        cell.setNameLabel(name: players[indexPath.row].name.description)
        cell.setScoreLabel(score: players[indexPath.row].score.description)
        
        if players[indexPath.row].turn == currentTurn {
            cell.cellView.backgroundColor = UIColor.green
        }else{
            cell.cellView.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return players.count
    }
}

