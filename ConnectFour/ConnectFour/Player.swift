//
//  Player.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 20.09.2022.
//

import Foundation

class Player {
    ///Имя игрока
    private let name: String
    ///Символ которым он будет играть
    private let symbol: String
    ///Символ для проверки победы
    private var symbolForCheck: String
    ///Количество очков текущего игрока
    private var score: Int = 0
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
        self.symbolForCheck = symbol + symbol + symbol + symbol
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getSymbol() -> String {
        return self.symbol
    }
    
    func getPlayerScore() -> Int {
        return self.score
    }
    
    func getSymbolForCheck() -> String {
        return self.symbolForCheck
    }
    
    func increaseScore(points: Int) {
        self.score += points
    }
    
    
}
