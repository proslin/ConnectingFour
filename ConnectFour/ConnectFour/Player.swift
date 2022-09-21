//
//  Player.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 20.09.2022.
//

import Foundation

class Player {
    ///Имя игрока
    let name: String
    ///Символ которым он будет играть
    let symbol: String
    ///Количество очков текущего игрока
    var score: Int = 0
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
    
    static func createPlayer(msg: String, symbol: String) -> Player {
        let name = readInput(message: msg)
        return Player(name: name, symbol: symbol)
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
