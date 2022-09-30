//
//  ConnectFourGame.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 20.09.2022.
//

import Foundation

class ConnectFourGame {
    /// Первый игрок
    private var firstPlayer: Player //= Player(name: "", symbol: "o")
    /// Второй игрок
    private var secondPlayer: Player //= Player(name: "", symbol: "*")
    /// Количество столбцов вводим с клавиатуры
    private var columns: Int = 7
    /// Количество строк вводим с клавиатуры
    private var rows : Int = 6
    /// Номер раунда игры
    private var rounds: Int = 1
    /// Игровое поле
    private var boardCells: [[String]] = []
    /// Признак конца игры
    private var isEndOfGame = false
    
    init(firstPlayer: Player, secondPlayer: Player) {
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
    }
    
    private func prepareGame() {
        readBoardDimensions()
        rounds = readNumberOfGames()
    }
    
    private func printStartedParam() {
        print("\(firstPlayer.getName()) VS \(secondPlayer.getName())")
        print("\(rows) X \(columns) board")
    }
    
    public func start() {
        prepareGame()
        printStartedParam()
        for round in (1...rounds) {
            if rounds > 1 {
                print("Game #\(round)")
            }
            initEmptyArray(row: rows, column: columns)
            printGameBoard(row: rows, column: columns)
            game(round: round)
            if isEndOfGame { break }
            if rounds > 1 {
                print("Score")
                print("\(firstPlayer.getName()):\(firstPlayer.getPlayerScore()) \(secondPlayer.getName()):\(secondPlayer.getPlayerScore())")
            }
        }
        
        print("Game over")
    }
    
    private func game(round: Int) {
        var playersQueue = (round % 2 != 0) ? [firstPlayer, secondPlayer] : [secondPlayer, firstPlayer]
        repeat {
            
            let currentPlayer = playersQueue.first!
            
            guard let colNum = readColumnNumber(message: "\(currentPlayer.getName()) turn:") else { return }
            let columnNumber = colNum
            guard let rowNumber = findRowNumber(colNum: columnNumber) else {
                print("\(columnNumber) \(Errors.fullColumn.rawValue)")
                continue
            }
            
            boardCells[rowNumber][columnNumber - 1] = currentPlayer.getSymbol()
            printGameBoard(row: rows, column: columns)
            if checkHorisontal(row: rowNumber, currentPlayer: currentPlayer) || checkVertical(column: columnNumber, currentPlayer: currentPlayer) || checkDiagonal(column: columnNumber - 1, row: rowNumber, currentPlayer: currentPlayer) {
                print("\(currentPlayer.getName()) won")
                currentPlayer.increaseScore(points: 2)
                break
            }
            
            if isBoardFull(arr: boardCells) {
                print("It is a draw")
                firstPlayer.increaseScore(points: 1)
                secondPlayer.increaseScore(points: 1)
                break
            }
            playersQueue.reverse()
            
        } while true
        
    }
    
    private func readBoardDimensions() {
        let message = """
        Set the board dimensions (Rows x Columns)
        Press Enter for default (6x7)
        """
        var dimension = String()
        repeat {
            print(message, terminator: "\n> ")
            dimension = readLine() ?? ""
        } while getDimensionsFromString(dimension) == nil
        
        guard let row = getDimensionsFromString(dimension)?.row,
              let column = getDimensionsFromString(dimension)?.column else { return }
        rows = row
        columns = column
    }
    
    private func readNumberOfGames() -> Int {
        let message = """
              Do you want to play single or multiple games?
              For a single game, input 1 or press Enter
              Input a number of games:
              """
        var gamesNumber = Int()
        repeat {
            print(message, terminator: "\n> ")
            let input = readLine()
            guard let input = input else { break }
            if input == "" {
                gamesNumber = 1
                break
            }
            guard let number = Int(input) else {
                print(Errors.invalidInput.rawValue)
                continue
            }
            
            gamesNumber = number
            print(gamesNumber == 1 ? "Single game" : "Total \(gamesNumber) games")
            break
        } while true
        
        return gamesNumber
    }
    
    private func printGameBoard(row: Int, column: Int) {
        print("  \((1...column).map{ String($0) }.joined(separator: " "))")
        printArray(arr: boardCells)
        var str: String = ""
        let count = 2 * column + 1
        for _ in (1...count) {
            str += "="
        }
        print(" \(str)")
    }
    
    private func initEmptyArray(row: Int, column: Int) {
        boardCells = [[String]](repeating: [String](repeating: " ", count: column), count: row)
    }
    
    private func printArray(arr: [[String]]) {
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
    
    private func findRowNumber(colNum: Int) -> Int? {
        var rowNum = Int()
        for j in (0...rows - 1).reversed() {
            if boardCells[j][colNum - 1] == " " {
                rowNum = j
                return rowNum
            }
        }
        return nil
    }
    
    private func checkHorisontal(row: Int, currentPlayer: Player) -> Bool {
        var str = String()
        str = boardCells[row].joined()
        if str.contains(currentPlayer.getSymbolForCheck()) { return true }
        return false
    }
    
    private func checkVertical(column: Int, currentPlayer: Player) -> Bool {
        var str = String()
        for j in (0...rows - 1) {
            str += boardCells[j][column - 1]
        }
        if str.contains(currentPlayer.getSymbolForCheck()) { return true }
        return false
    }
    
    private func checkDiagonal(column: Int, row: Int, currentPlayer: Player) -> Bool {
        var strUp = String()
        var strDown = String()
        for i in (row - 3...row + 3) {
            for j in (column - 3...column + 3) {
                if i >= 0 && j >= 0 && i < rows && j < columns{
                    //проверяем на главную диагональ
                    if i - j == row - column {
                        strUp += boardCells[i][j]
                    }
                    //проверяем на второстепенную диагональ
                    if i + j == row + column {
                        strDown += boardCells[i][j]
                    }
                }
            }
        }
        if strUp.contains(currentPlayer.getSymbolForCheck()) || strDown.contains(currentPlayer.getSymbolForCheck()) { return true }
        return false
    }
    
    private func isEnd(input: String) -> Bool {
        if input.lowercased() == "end" { return true }
        return false
    }
    
    private func isBoardFull(arr: [[String]]) -> Bool{
        for i in (0...rows - 1) {
            for j in (0...columns - 1) {
                if arr[i][j] == " " { return false }
            }
        }
        return true
    }
    
    private func readColumnNumber(message: String) -> Int? {
        var columnNumber = Int()
        repeat {
            print(message, terminator: "\n> ")
            guard let input = readLine() else {
                print(Errors.notANumber.rawValue)
                continue
            }
            if isEnd(input: input) {
                isEndOfGame = true
                return nil
            }
            guard let columnNum = Int(input) else {
                print(Errors.notANumber.rawValue)
                continue
            }
            if columnNum < 1 || columnNum > columns {
                print("\(Errors.invalidColumn.rawValue) (1 - \(columns))")
                continue
            }
            columnNumber = columnNum
            break
        } while true
        return columnNumber
    }
    
    private func getDimensionsFromString(_ input: String) -> (row: Int, column: Int)? {
        var rowCount : Int = 6
        var columnCount: Int = 7
        if input == "" { return (row: rowCount, column: columnCount) }
        let filteredInput = input.lowercased().filter { $0 != " " }
        if !(filteredInput.contains("x")) {
            print(Errors.invalidInput.rawValue)
            return nil
        }
        let array = filteredInput.components(separatedBy: "x")
        if let rowStr = array.first, let columnStr = array.last {
            if let row = Int(rowStr), let column = Int(columnStr) {
                rowCount = row
                columnCount = column
            } else {
                print(Errors.invalidInput.rawValue)
                return nil
            }
            if !(5...9).contains(rowCount) {
                print(Errors.invalidRowNumber.rawValue)
                return nil
            } else if !(5...9).contains(columnCount) {
                print(Errors.invalidColumnNumber.rawValue)
                return nil
            }
        } else {
            print(Errors.invalidInput.rawValue)
            return nil
        }
        return (row: rowCount, column: columnCount)
    }
}
