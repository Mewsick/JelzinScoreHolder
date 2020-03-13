//
//  API.swift
//  jelzin
//
//  Created by Eric Johansson on 2020-03-13.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import Foundation

struct TeamAPI{
    
    let headers = [
        "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
        "x-rapidapi-key": "e46acfe96cmsha0406b68500297fp14fbdbjsn0e199568d6b2"
    ]
    
    
    func APIRequest(completion: @escaping(Result<team, Error>) -> Void){
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v2/statistics/2/40")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } /*else {
                let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
            }*/
            
            if let unwrappedData = data {
                print("We got data! \(String(data: unwrappedData, encoding: String.Encoding.utf8) ?? "No data")")
                //print(newSearchInput)
                do {
                    let decoder = JSONDecoder()
                    let teamStats: team = try decoder.decode(team.self, from: unwrappedData)
                    print("total wins for Liverpool: \(teamStats.api.statistics.matchs.wins)")
                    completion(.success(teamStats))
                } catch {
                    print("Couldnt parse JSON..")
                }
            }
            
        })

        dataTask.resume()
    }
}
