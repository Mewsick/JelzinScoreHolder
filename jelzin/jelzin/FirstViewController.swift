//
//  FirstViewController.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

struct player {
    var name: String
    var score: Int
}

class FirstViewController: UIViewController, CallbackDelegate{
   
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var addPlayer: UIButton!
    
    @IBOutlet var touchView: UIView!
    var listOfPlayers: [player] = []
    var hasBegun: Bool = false
    
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
        print(listOfPlayers)
        if listOfPlayers.count != 0 {
            performSegue(withIdentifier: "secondSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController{
            let vc = segue.destination as? ViewController
            vc?.players = listOfPlayers
            vc?.delegate = self
       }
    }
    
    @IBAction func addPlayerPressed(_ sender: Any) {
        if inputField.text != ""{
            let text: String = inputField.text?.uppercased() ?? "player\(listOfPlayers.count)"
            print(text)
            listOfPlayers.append(player(name: text, score: 0))
            print(listOfPlayers)
            inputField.text = ""
            self.view.endEditing(true)
        }
    }
    
    func setPlayers(players: [player]) {
        listOfPlayers = players
        print("players set: \(listOfPlayers)")
    }
    
    func setHasBegun(b: Bool) {
           hasBegun = b
       }
}
