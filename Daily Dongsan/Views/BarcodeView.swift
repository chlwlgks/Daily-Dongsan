//
//  BarcodeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/10/24.
//

import SwiftUI
import SwiftData

struct BarcodeView: View {
    @State private var savedCode: String? = UserDefaults.standard.string(forKey: "savedCode")
    
    @State private var isShowingBarcodeSetupView: Bool = false
    
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
    
    var body: some View {
        NavigationStack {
            if let savedCode {
                GeometryReader { geometry in
                    let barwidth = geometry.size.width / 130
                    let barheight = barwidth * 35
                    
                    VStack {
                        HStack(spacing: 0) {
                            ForEach(Array(generateCode39(input: savedCode)), id: \.self) { bar in
                                Rectangle()
                                    .fill(bar == "1" ? Color.black : Color.white)
                                    .frame(width: barwidth, height: barheight)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        
                        Text(savedCode)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()
                .navigationTitle("학생증")
            } else {
                Button {
                    isShowingBarcodeSetupView = true
                } label: {
                    Text("학생증 시작하기")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.accent)
                        }
                }
                .navigationTitle("학생증")
                .padding(.horizontal)
                .padding(.horizontal)
            }
        }
        .onAppear {
            if savedCode == nil {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    isShowingBarcodeSetupView = true
                }
            }
        }
        .sheet(isPresented: $isShowingBarcodeSetupView) {
            BarcodeSetupView(isShowing: $isShowingBarcodeSetupView, inputCode: $savedCode)
        }
    }
    
    private func generateCode39(input: String) -> String {
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

struct BarcodeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isShowing: Bool
    @Binding var inputCode: String?
    
    @State private var temporaryCode: String = ""
    @State private var isValid: Bool = true
    
    private class HapticManager {
        static let instance = HapticManager()
        
        func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
            UINotificationFeedbackGenerator().notificationOccurred(notificationType)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("학생증 시작하기")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        Image(systemName: "person.text.rectangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.accent)
                            .frame(width: 50, height: 50)
                        Text("학생증의 프로필 사진 밑에 있는 7자리 코드를 적어주세요.")
                        
                    }
                    HStack(spacing: 16) {
                        Image(systemName: "person.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.accent)
                            .frame(width: 50, height: 50)
                        Text("학생증 코드는 한 번 등록하면 변경할 수 없습니다.")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
                Group {
                    TextField("학생증 코드", text: $temporaryCode)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray)
                        }
                        .keyboardType(.asciiCapable)
                        .onChange(of: temporaryCode, { oldValue, newValue in
                            if newValue.count > 7 {
                                temporaryCode = String(newValue.prefix(7))
                            }
                        })
                        .onSubmit {
                            validateCode()
                        }
                    if !isValid {
                        Text("학생증 코드는 7글자여야 합니다.")
                            .foregroundStyle(.red)
                    } else {
                        Text("학생증 코드는 7글자여야 합니다.")
                            .foregroundStyle(.background)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
                Button {
                    validateCode()
                    if isValid {
                        UserDefaults.standard.set(temporaryCode, forKey: "savedCode")
                        inputCode = temporaryCode
                        isShowing = false
                        HapticManager.instance.notification(notificationType: .success)
                    }
                } label: {
                    Text("계속")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
    }
    
    private func validateCode() {
        isValid = temporaryCode.count == 7
    }
}

#Preview {
    BarcodeView()
}
