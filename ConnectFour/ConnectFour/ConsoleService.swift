//
//  ConsoleService.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 30.09.2022.
//

import Foundation

struct ConsoleService {
    static func readInput(message: String) -> String {
        var inputStr: String
        repeat {
            print(message, terminator: "\n> ")
            inputStr = readLine() ?? ""
        } while inputStr.isEmpty
        
        return inputStr
    }
}
