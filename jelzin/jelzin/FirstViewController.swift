//
//  FirstViewController.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController{
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var addPlayer: UIButton!
    
    var listOfPlayers: [player] = []
    
    struct player {
        var name: String
        var score: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   @IBAction func pressForReadyToPlay(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController{
            let vc = segue.destination as? ViewController
            vc?.players = listOfPlayers
       }
    }
    
    @IBAction func addPlayerPressed(_ sender: Any) {
        if inputField.text != ""{
            let text: String = inputField.text?.uppercased() ?? "player\(listOfPlayers.count)"
            print(text)
            let _player = player(name: text, score: 0)
            listOfPlayers.append(_player)
            print(listOfPlayers)
            inputField.text = ""
        }
    }
    
    /*func inputFieldAction(_ sender: Any) {
        let text = inputField.description
        print(text)
        print(listOfPlayers)
    }*/
}
