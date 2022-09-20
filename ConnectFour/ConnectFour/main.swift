//
//  main.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 12.09.2022.
//

import Foundation

struct Player {
    let name: String
    let symbol: String
    var isFirst: Bool
    var score: Int = 0
    
    mutating func increaseScore(points: Int) {
        self.score += points
    }
}

var firstPlayerName = String()
var secondPlayerName = String()
var columns = Int()
var rows = Int()
//let firstPlayerSymbol = "o"
//let secondPlayerSymbol = "*"
var arr = [[String]]()
//var score = [String: Int]()
var totalGames = Int()
var isEndOfGame = false

enum ErrosMessage: String {
    case invalidInput = "Invalid input"
    case invalidRowNumber = "Board rows should be from 5 to 9"
    case invalidColumnNumber = "Board columns should be from 5 to 9"
    case invalidColumn = "The column number is out of range"
    case notANumber = "Incorrect column number"
    case fullColumn = " column is full"
}

func readInput(message: String) -> String {
    var inputStr: String
    repeat {
        print(message)
        inputStr = readLine() ?? ""
    } while inputStr.isEmpty
    
    return inputStr
}

func getDimensionsFromString(_ input: String) -> (row: Int, column: Int)? {
    var rowCount : Int = 6
    var columnCount: Int = 7
    if input == "" { return (row: rowCount, column: columnCount) }
    let filteredInput = input.lowercased().filter { $0 != " " }
    if !(filteredInput.contains("x")) {
        print(ErrosMessage.invalidInput.rawValue)
        return nil
    }
    let array = filteredInput.components(separatedBy: "x")
    if let rowStr = array.first, let columnStr = array.last {
        if let row = Int(rowStr), let column = Int(columnStr) {
            rowCount = row
            columnCount = column
        } else {
            print(ErrosMessage.invalidInput.rawValue)
            return nil
        }
        if !(5...9).contains(rowCount) {
            print(ErrosMessage.invalidRowNumber.rawValue)
            return nil
        } else if !(5...9).contains(columnCount) {
            print(ErrosMessage.invalidColumnNumber.rawValue)
            return nil
        }
       
    } else {
        print(ErrosMessage.invalidInput.rawValue)
        return nil
    }
    return (row: rowCount, column: columnCount)
}


func readBoardDimensions() {
    let message = """
    Set the board dimensions (Rows x Columns)
    Press Enter for default (6x7)
    """
    var dimension = String()
    repeat{
        print(message)
        dimension = readLine() ?? ""
    } while getDimensionsFromString(dimension) == nil
    
    guard let row = getDimensionsFromString(dimension)?.row,
          let column = getDimensionsFromString(dimension)?.column else { return }
        rows = row
        columns = column
    
}

func readNumberOfGames() -> Int {
    let message = """
          Do you want to play single or multiple games?
          For a single game, input 1 or press Enter
          Input a number of games:
          """
    var gamesNumber = Int()
    repeat{
        print(message)
        let input = readLine()
        guard let input = input else { break }
        if input == "" {
            gamesNumber = 1
            break
        }
        guard let number = Int(input) else {
            print(ErrosMessage.invalidInput.rawValue)
            continue
        }
        
        gamesNumber = number
        break
    } while true
    
    return gamesNumber
}

func readColumnNumber(message: String) -> Int? {
    var columnNumber = Int()
    repeat{
      print(message)
        guard let input = readLine() else {
            print(ErrosMessage.notANumber.rawValue)
            continue
            }
        if isEnd(input: input) {
            isEndOfGame = true
            return nil
        }
        guard let columnNum = Int(input) else {
            print(ErrosMessage.notANumber.rawValue)
            continue
        }
        if columnNum < 1 || columnNum > columns {
            print("\(ErrosMessage.invalidColumn.rawValue) (1 - \(columns))")
           continue
        }
        columnNumber = columnNum
        break
    } while true
    return columnNumber
}

func startGame() {
    print("Connect Four")
    firstPlayerName = readInput(message: "First player's name")
    secondPlayerName = readInput(message: "Second player's name")
    readBoardDimensions()
    totalGames = readNumberOfGames()
    totalGames == 1 ? print("Single game") : print("Total \(totalGames) games")
    
}

func printStartedParam() {
    print("\(firstPlayer.name) VS \(secondPlayer.name)")
    print("\(rows) X \(columns) board")
}

func printGameBoard(row: Int, column: Int) {
   print("  \((1...column).map{ String($0) }.joined(separator: " "))")
    printArray(arr: arr)
    var str: String = ""
    let count = 2 * column + 1
    for _ in (1...count) {
        str += "="
    }
    print(" \(str)")
}

func initEpptyArray(row: Int, column: Int) {
   arr = [[String]](repeating: [String](repeating: " ", count: column), count: row)
}

func printArray(arr: [[String]]) {
    for i in (0...(rows - 1 )) {
        var str = String()
        for j in (0...(columns - 1 )) {
            if j == 0 {
                str += "\(i + 1)|\(arr[i][j])"
            } else if j == (columns - 1) {
                str += "|\(arr[i][j])|"
            } else {
                str += "|\(arr[i][j])"}
        }
        print(str)
    }
            
}

func findRowNumber(colNum: Int) -> Int? {
    var rowNum = Int()
    for j in (0...rows - 1).reversed() {
        if arr[j][colNum - 1] == " " {
            rowNum = j
            return rowNum
        }
    }
    return nil
}
func getSymbolForCheck(symbol: String) -> String {
    return (symbol + symbol + symbol + symbol)
}

func checkHorisontal(row: Int, symbol: String) -> Bool {
    var str = String()
    str = arr[row].joined()
    if str.contains(getSymbolForCheck(symbol: symbol)) { return true }
    return false
}

func checkVertical(column: Int, symbol: String) -> Bool {
    var str = String()
    for j in (0...rows - 1) {
        str += arr[j][column - 1]
    }
    if str.contains(getSymbolForCheck(symbol: symbol)) { return true }
    return false
}

func checkDiagonal(column: Int, row: Int, symbol: String) -> Bool {
    var strUp = String()
    var strDown = String()
    for i in (row - 3...row + 3) {
        for j in (column - 3...column + 3) {
            if i >= 0 && j >= 0 && i < rows && j < columns{
                //проверяем на главную диагональ
                if i - j == row - column {
                    strUp += arr[i][j]
                }
                //проверяем на второстепенную диагональ
                if i + j == row + column {
                    strDown += arr[i][j]
                }
            }
        }
    }
    if strUp.contains(getSymbolForCheck(symbol: symbol)) || strDown.contains(getSymbolForCheck(symbol: symbol)) { return true }
    return false
}

func isEnd(input: String) -> Bool {
    if input.lowercased() == "end" { return true }
    return false
}

func isBoardFull(arr: [[String]]) -> Bool{
    for i in (0...rows - 1) {
        for j in (0...columns - 1) {
            if arr[i][j] == " " { return false }
        }
    }
    return true
}

func game() {
    var player = String()
    var i : Int = 1
    
    var symbol: String
    repeat {
        
        if firstPlayer.isFirst {
            if (i % 2 != 0) {
                player = firstPlayer.name
            } else {
                player = secondPlayer.name
            }
        } else if secondPlayer.isFirst {
            if (i % 2 != 0) {
                player = secondPlayer.name
            } else {
                player = firstPlayer.name
            }
        }
        
    guard let colNum = readColumnNumber(message: "\(player) turn:") else { return }
    let columnNumber = colNum
        guard let rowNumber = findRowNumber(colNum: columnNumber) else {
            print("\(columnNumber) \(ErrosMessage.fullColumn.rawValue)")
            continue
        }
    
        if player == firstPlayer.name {
            arr[rowNumber][columnNumber - 1] = firstPlayer.symbol
            symbol = firstPlayer.symbol
        } else {
            arr[rowNumber][columnNumber - 1] = secondPlayer.symbol
            symbol = secondPlayer.symbol
        }
        printGameBoard(row: rows, column: columns)

        if checkHorisontal(row: rowNumber, symbol: symbol) || checkVertical(column: columnNumber, symbol: symbol) || checkDiagonal(column: columnNumber - 1, row: rowNumber, symbol: symbol) {
            print("\(player) won")
            if player == firstPlayer.name {
                firstPlayer.increaseScore(points: 2)
            } else if player == secondPlayer.name {
                secondPlayer.increaseScore(points: 2)
            }
            firstPlayer.isFirst.toggle()
            secondPlayer.isFirst.toggle()
            break
        }
        
        if isBoardFull(arr: arr) {
            print("It is a draw")
            firstPlayer.increaseScore(points: 1)
            secondPlayer.increaseScore(points: 2)
            firstPlayer.isFirst.toggle()
            secondPlayer.isFirst.toggle()
            break
        }
        i += 1
        
    } while true
    
}


var firstPlayer : Player
var secondPlayer : Player
startGame()
firstPlayer = Player(name: firstPlayerName, symbol: "0", isFirst: true, score: 0)
secondPlayer = Player(name: secondPlayerName, symbol: "*", isFirst: false, score: 0)
printStartedParam()

for i in (1...totalGames) {
    if totalGames > 1 {
        print("Game #\(i)")
    }
    initEpptyArray(row: rows, column: columns)
    printGameBoard(row: rows, column: columns)
    game()
    if isEndOfGame { break }
    if totalGames > 1 {
        print("Score")
        print("\(firstPlayer.name):\(firstPlayer.score) \(secondPlayer.name):\(secondPlayer.score)")
    }
}
print("Game over")

