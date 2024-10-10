//
//  BarcodeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/10/24.
//

import SwiftUI

struct BarcodeView: View {
    private let code39Patterns: [Character: String] = [
        "0": "101001101101", "1": "110100101011", "2": "101100101011", "3": "110110010101",
        "4": "101001101011", "5": "110100110101", "6": "101100110101", "7": "101001011011",
        "8": "110100101101", "9": "101100101101", "A": "110101001011", "B": "101101001011",
        "C": "110110100101", "D": "101011001011", "E": "110101100101", "F": "101101100101",
        "G": "101010011011", "H": "110101001101", "I": "101101001101", "J": "101011001101",
        "K": "110101010011", "L": "101101010011", "M": "110110101001", "N": "101011010011",
        "O": "110101101001", "P": "101101101001", "Q": "101010110011", "R": "110101011001",
        "S": "101101011001", "T": "101011011001", "U": "110010101011", "V": "100110101011",
        "W": "110011010101", "X": "100101101011", "Y": "110010110101", "Z": "100110110101",
        "*": "100101101101"
    ]
    
    private var input = "DS00773"
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(generateCode39(input)), id: \.self) { bar in
                Rectangle()
                    .fill(bar == "1" ? Color.black : Color.white)
                    .frame(width: 3, height: 100)
            }
        }
    }
    
    func generateCode39(_ input: String) -> String {
        var code39 = code39Patterns["*"]! + "0"
        
        for character in input.uppercased() {
            if let pattern = code39Patterns[character] {
                code39 += pattern + "0"
            }
        }
        
        code39 += code39Patterns["*"]!
        return code39
    }
}

#Preview {
    BarcodeView()
}
