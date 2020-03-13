//
//  teamProperties.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-03-13.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import Foundation

struct team: Decodable {
    let api : API
}

struct API: Decodable{
    let statistics: Statistics
}

struct Statistics: Decodable{
    let matchs: Matchs
}

struct Matchs: Decodable{
    let wins: Wins
}

struct Wins: Decodable{
    let total: Int
}
