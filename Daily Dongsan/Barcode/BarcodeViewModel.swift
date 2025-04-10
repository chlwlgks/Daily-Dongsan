//
//  BarcodeViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/10/25.
//

import SwiftUI

class BarcodeViewModel: ObservableObject {
    @AppStorage("studentID") private var studentID: String?
    
    private let code39Patterns: [Character: String] = [
        "0": "101001101101", "1": "110100101011", "2": "101100101011", "3": "110110010101",
        "4": "101001101011", "5": "110100110101", "6": "101100110101", "7": "101001011011",
        "8": "110100101101", "9": "101100101101", "D": "101011001011", "S": "101101011001",
        "*": "100101101101"
    ]
    
    func generateCode39(input: String) -> String {
        var code39 = code39Patterns["*"]! + "0"
        
        for character in input {
            if let pattern = code39Patterns[character] {
                code39 += pattern + "0"
            }
        }
        
        code39 += code39Patterns["*"]!
        return code39
    }
    
    @Published var isValid = true
    
    func validateCode(_ temporaryCode: String) {
        if temporaryCode.count == 5 && temporaryCode.allSatisfy(\.isNumber) {
            isValid = true
        } else {
            isValid = false
        }
    }
}
