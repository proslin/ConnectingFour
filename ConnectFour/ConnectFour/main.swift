//
//  main.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 12.09.2022.
//

import Foundation

print("Connect Four")

var firstPlayer: Player = Player(name: ConsoleService.readInput(message: "First player's name"), symbol: "o")
var secondPlayer: Player = Player(name: ConsoleService.readInput(message: "Second player's name"), symbol: "*")
var game = ConnectFourGame(firstPlayer: firstPlayer, secondPlayer: secondPlayer)

game.start()

