//
//  TableViewCell.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-02-20.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func setScoreLabel(score: String){
        self.scoreLabel.text = score
    }


}
