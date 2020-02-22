//
//  ViewController.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

protocol CallbackDelegate: NSObjectProtocol {
    func setPlayers(players: [player])
}

let screenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var inputName: String = ""
    var players: [player] = []
    var scoreToBeAdded = 0
    var delegate: CallbackDelegate?
    var turns: Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var onePlusButton: UIButton!
    @IBOutlet weak var fivePlusButton: UIButton!
    @IBOutlet weak var tenPlusButton: UIButton!
    @IBOutlet weak var oneMinusButton: UIButton!
    @IBOutlet weak var fiveMinusButton: UIButton!
    @IBOutlet weak var tenMinusButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        tableView.dataSource = self
        tableView.delegate = self
        if players.count < 6 {
            tableView.rowHeight = ((screenHeight - 130) * 0.6)/CGFloat(players.count)
        }else{
            tableView.rowHeight = ((screenHeight - 130) * 0.6)/CGFloat(5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = delegate {
            delegate.setPlayers(players: players)
            print("ViewWillDisappear\(players)")
        } else {
            print("Delegate is null")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
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
    @IBAction func tenMinusPressed(_ sender: Any) {
        
        //players.forEach { $0.score = 0)}
        scoreToBeAdded += -10
        scoreLabel.text = scoreToBeAdded.description
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            players[indexPath.row].score += scoreToBeAdded
            print(players)
            scoreToBeAdded = 0
            scoreLabel.text = scoreToBeAdded.description
            players = players.sorted(by: { $0.score < $1.score })
            tableView.reloadData()
            turns += 1
            if turns == players.count{
                turns = 0
                if players.last!.score > 49{
                    scoreLabel.text = "\(players.first!.name) vann!"
                    print("\(players.first!.name) vann!")
                }
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewCell
        cell.setNameLabel(name: players[indexPath.row].name.description)
        cell.setScoreLabel(score: players[indexPath.row].score.description)
        return cell
    }
}

