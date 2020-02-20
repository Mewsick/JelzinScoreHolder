//
//  ViewController.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var inputName: String = ""
    var players: [FirstViewController.player] = []
    var row = 0
    var scoreToBeAdded = 0
 
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var fivePlusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    @IBAction func addToPlayerButton(_ sender: Any) {
        players[row].score = scoreToBeAdded
        print(players)
        scoreToBeAdded = 0
        scoreLabel.text = scoreToBeAdded.description
    }
    
    @IBAction func fivePlusPressed(_ sender: Any) {
        scoreToBeAdded += 5
        scoreLabel.text = scoreToBeAdded.description
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //localCurrentCity = filteredCities[indexPath.row]
        row = indexPath.row
        //performSegue(withIdentifier: "mySegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = players[indexPath.row].name
        return cell
    }
    
}

