//
//  NetworkManager.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import Foundation
protocol NetworkManagerDelegate{
    func updateUI(timings: SalahModel)
    func netwrokError(error: Error)
}



struct NetworkManager{
    
    //static let shared = NetworkManager()
    //init(){}
    var delegate: NetworkManagerDelegate?
    
    func fetchSalahTimings(){
        let headers = [
            "X-RapidAPI-Key": "cd044bcf3emsh33f0a75fd47be40p1b66fbjsnd35495da702a",
            "X-RapidAPI-Host": "muslimsalat.p.rapidapi.com"
        ]

        let url = URL(string: "https://muslimsalat.p.rapidapi.com/kupwara.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error{
                print("Fetching issue: \(error)")
                delegate?.netwrokError(error: error)
                return
            }
            
            if let data = data{
                parseJSON(unparsedData: data)
            }
            
        }.resume()
        
    }
    func parseJSON(unparsedData: Data){
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(SalahModel.self, from: unparsedData)
            delegate?.updateUI(timings: decodedData)
        }catch{
            print("Error parsing data: \(error)")
            delegate?.netwrokError(error: error)
        }
        
    }
    
    
    
}
