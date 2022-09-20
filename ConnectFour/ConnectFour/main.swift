//
//  main.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 12.09.2022.
//

import Foundation

var firstPlayer = String()
var secondPlayer = String()
var columns = Int()
var rows = Int()
let firstPlayerSymbol = "o"
let secondPlayerSymbol = "*"
var arr = [[String]]()

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
    let filteredInput = input.lowercased().filter { $0 != " "}
    if !(filteredInput.contains("x")) {
        print(ErrosMessage.invalidInput.rawValue)
        return nil}
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

func readColumnNumber(message: String) -> Int? {
    var columnNumber = Int()
    repeat{
      print(message)
        guard let input = readLine() else {
            print(ErrosMessage.notANumber.rawValue)
            continue
            }
        if isEnd(input: input) {
            
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
    firstPlayer = readInput(message: "First player's name \("\n") >")
    secondPlayer = readInput(message: "Second player's name")
    readBoardDimensions()
    
}

func printStartedParam() {
    print("\(firstPlayer) VS \(secondPlayer)")
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

func checkHorisontal(row: Int, symbol: String) -> Bool {
    var str = String()
    let symbolForCheck = symbol + symbol + symbol + symbol
    str = arr[row].joined()
    if str.contains(symbolForCheck) { return true }
    return false
}

func checkVertical(column: Int, symbol: String) -> Bool {
    var str = String()
    let symbolForCheck = symbol + symbol + symbol + symbol
    for j in (0...rows - 1) {
        str += arr[j][column - 1]
    }
    if str.contains(symbolForCheck) { return true }
    return false
}

func checkDiagonal(column: Int, row: Int, symbol: String) -> Bool {
    var strUp = String()
    var strDown = String()
    let symbolForCheck = symbol + symbol + symbol + symbol
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
    if strUp.contains(symbolForCheck) || strDown.contains(symbolForCheck) { return true }
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
    var player : String
    var i : Int = 1
    var symbol: String
   // var col = readColumnNumber(message: "\(firstPlayer) turn:")
    repeat {
        if (i % 2 != 0) { player = firstPlayer } else { player = secondPlayer }
    guard let colNum = readColumnNumber(message: "\(player) turn:") else { return }
    let columnNumber = colNum
   // print(columnNumber)
    //print(findRowNumber(colNum: columnNumber))
        guard let rowNumber = findRowNumber(colNum: columnNumber) else {
            print("\(columnNumber) \(ErrosMessage.fullColumn.rawValue)")
            continue
        }
    
        if player == firstPlayer {
        arr[rowNumber][columnNumber - 1] = firstPlayerSymbol
            symbol = firstPlayerSymbol
        } else {
            arr[rowNumber][columnNumber - 1] = secondPlayerSymbol
            symbol = secondPlayerSymbol
        }
   printGameBoard(row: rows, column: columns)
        // проверяем есть ли 4 одинаковых символа в ряд
        if checkHorisontal(row: rowNumber, symbol: symbol) {
            print("\(player) wins")
            break
        }
        // проверяем есть ли 4 одинаковых символа в столбце
        if checkVertical(column: columnNumber, symbol: symbol) {
            print("\(player) wins")
            break
        }
        
        if checkDiagonal(column: columnNumber - 1, row: rowNumber, symbol: symbol){
            print("\(player) wins")
            //print("Game over")
            break
        }
        
        if isBoardFull(arr: arr) {
            print("It is a draw")
            break
        }
        i += 1
        
    } while true
    
//    repeat{
//       print("\(firstPlayer) turn:")
//        input = readLine() ?? ""
//    } while isEnd(input: input)
//    printGameBoard(row: rows, column: columns)
}

startGame()
printStartedParam()
arr = [[String]](repeating: [String](repeating: " ", count: columns), count: rows)
printGameBoard(row: rows, column: columns)

game()
print("Game over")

