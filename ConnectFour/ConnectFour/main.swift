//
//  main.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 12.09.2022.
//

import Foundation

print("Connect Four")

var firstPlayer: Player = Player.createPlayer(msg: "First player's name", symbol: "o", isFirst: true)
var secondPlayer: Player = Player.createPlayer(msg: "Second player's name", symbol: "*", isFirst: false)
var game = ConnectFourGame(onePlayer: firstPlayer, twoPlayer: secondPlayer)

game.prepareGame()
game.printStartedParam()
game.start()

