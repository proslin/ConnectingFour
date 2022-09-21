//
//  Player.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 20.09.2022.
//

import Foundation

class Player {
    let name: String
    let symbol: String
    var isFirst: Bool
    var score: Int = 0
    
    init(name: String, symbol: String, isFirst: Bool) {
        self.name = name
        self.symbol = symbol
        self.isFirst = isFirst
    }
    
    static func createPlayer(msg: String, symbol: String, isFirst: Bool) -> Player {
        let name = readInput(message: msg)
        return Player(name: name, symbol: symbol, isFirst: isFirst)
    }
    
    func increaseScore(points: Int) {
        self.score += points
    }
    
    static func readInput(message: String) -> String {
        var inputStr: String
        repeat {
            print(message)
            inputStr = readLine() ?? ""
        } while inputStr.isEmpty
        
        return inputStr
    }
}
