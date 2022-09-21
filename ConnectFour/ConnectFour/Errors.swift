//
//  Errors.swift
//  ConnectFour
//
//  Created by Lina Prosvetova on 20.09.2022.
//

import Foundation

enum Errors: String {
    case invalidInput = "Invalid input"
    case invalidRowNumber = "Board rows should be from 5 to 9"
    case invalidColumnNumber = "Board columns should be from 5 to 9"
    case invalidColumn = "The column number is out of range"
    case notANumber = "Incorrect column number"
    case fullColumn = " column is full"
}
