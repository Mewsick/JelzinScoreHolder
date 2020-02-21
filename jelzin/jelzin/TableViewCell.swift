//
//  TableViewCell.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-20.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    func setScoreLabel(score: String){
        self.playerScoreLabel.text = score
    }
    
    func setNameLabel(name: String){
        self.playerNameLabel.text = name
    }
}
