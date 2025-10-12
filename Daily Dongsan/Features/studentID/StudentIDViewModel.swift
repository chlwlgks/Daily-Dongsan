//
//  StudentIDViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/10/25.
//

import SwiftUI

enum BarModule {
    case narrow, wide
}

@Observable
class StudentIDViewModel {
    private let code39Patterns: [Character: [BarModule]] = [
        "*": [.narrow,   .wide, .narrow, .narrow,   .wide, .narrow,   .wide, .narrow, .narrow],
        "0": [.narrow, .narrow, .narrow,   .wide,   .wide, .narrow,   .wide, .narrow, .narrow],
        "1": [  .wide, .narrow, .narrow,   .wide, .narrow, .narrow, .narrow, .narrow,   .wide],
        "2": [.narrow, .narrow,   .wide,   .wide, .narrow, .narrow, .narrow, .narrow,   .wide],
        "3": [  .wide, .narrow,   .wide,   .wide, .narrow, .narrow, .narrow, .narrow, .narrow],
        "4": [.narrow, .narrow, .narrow,   .wide,   .wide, .narrow, .narrow, .narrow,   .wide],
        "5": [  .wide, .narrow, .narrow,   .wide,   .wide, .narrow, .narrow, .narrow, .narrow],
        "6": [.narrow, .narrow,   .wide,   .wide,   .wide, .narrow, .narrow, .narrow, .narrow],
        "7": [.narrow, .narrow, .narrow,   .wide, .narrow, .narrow,   .wide, .narrow,   .wide],
        "8": [  .wide, .narrow, .narrow,   .wide, .narrow, .narrow,   .wide, .narrow, .narrow],
        "9": [.narrow, .narrow,   .wide,   .wide, .narrow, .narrow,   .wide, .narrow, .narrow],
        "A": [  .wide, .narrow, .narrow, .narrow, .narrow,   .wide, .narrow, .narrow,   .wide],
        "B": [.narrow, .narrow,   .wide, .narrow, .narrow,   .wide, .narrow, .narrow,   .wide],
        "C": [  .wide, .narrow,   .wide, .narrow, .narrow,   .wide, .narrow, .narrow, .narrow],
        "D": [.narrow, .narrow, .narrow, .narrow,   .wide,   .wide, .narrow, .narrow,   .wide],
        "E": [  .wide, .narrow, .narrow, .narrow,   .wide,   .wide, .narrow, .narrow, .narrow],
        "F": [.narrow, .narrow,   .wide, .narrow,   .wide,   .wide, .narrow, .narrow, .narrow],
        "G": [.narrow, .narrow, .narrow, .narrow, .narrow,   .wide,   .wide, .narrow,   .wide],
        "H": [  .wide, .narrow, .narrow, .narrow, .narrow,   .wide,   .wide, .narrow, .narrow],
        "I": [.narrow, .narrow,   .wide, .narrow, .narrow,   .wide,   .wide, .narrow, .narrow],
        "J": [.narrow, .narrow, .narrow, .narrow,   .wide,   .wide,   .wide, .narrow, .narrow],
        "K": [  .wide, .narrow, .narrow, .narrow, .narrow, .narrow, .narrow,   .wide,   .wide],
        "L": [.narrow, .narrow,   .wide, .narrow, .narrow, .narrow, .narrow,   .wide,   .wide],
        "M": [  .wide, .narrow,   .wide, .narrow, .narrow, .narrow, .narrow,   .wide, .narrow],
        "N": [.narrow, .narrow, .narrow, .narrow,   .wide, .narrow, .narrow,   .wide,   .wide],
        "O": [  .wide, .narrow, .narrow, .narrow,   .wide, .narrow, .narrow,   .wide, .narrow],
        "P": [.narrow, .narrow,   .wide, .narrow,   .wide, .narrow, .narrow,   .wide, .narrow],
        "Q": [.narrow, .narrow, .narrow, .narrow, .narrow, .narrow,   .wide,   .wide,   .wide],
        "R": [  .wide, .narrow, .narrow, .narrow, .narrow, .narrow,   .wide,   .wide, .narrow],
        "S": [.narrow, .narrow,   .wide, .narrow, .narrow, .narrow,   .wide,   .wide, .narrow],
        "T": [.narrow, .narrow, .narrow, .narrow,   .wide, .narrow,   .wide,   .wide, .narrow],
        "U": [  .wide,   .wide, .narrow, .narrow, .narrow, .narrow, .narrow, .narrow,   .wide],
        "V": [.narrow,   .wide,   .wide, .narrow, .narrow, .narrow, .narrow, .narrow,   .wide],
        "W": [  .wide,   .wide,   .wide, .narrow, .narrow, .narrow, .narrow, .narrow, .narrow],
        "X": [.narrow,   .wide, .narrow, .narrow,   .wide, .narrow, .narrow, .narrow,   .wide],
        "Y": [  .wide,   .wide, .narrow, .narrow,   .wide, .narrow, .narrow, .narrow, .narrow],
        "Z": [.narrow,   .wide,   .wide, .narrow,   .wide, .narrow, .narrow, .narrow, .narrow],
    ]
    
    func generateCode39(from input: String) -> [BarModule] {
        var code39 = code39Patterns["*"]! + [.narrow]
        
        for character in input {
            if let pattern = code39Patterns[character] {
                code39 += pattern
                code39 += [.narrow]
            }
        }
        
        code39 += code39Patterns["*"]!
        return code39
    }
}
