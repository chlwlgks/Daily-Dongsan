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
        "8": "110100101101", "9": "101100101101", "D": "101011001011", "S": "101101011001",
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
                .frame(maxWidth: 450)
            }
        }
        .onAppear {
            savedCode = UserDefaults.standard.string(forKey: "savedCode")
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
        
        for character in input {
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
                        Text("학생증의 증명사진 밑에 있는 코드를 입력해 주세요.")
                        
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
                
                Group {
                    VStack {
                        HStack(spacing: 16) {
                            Text("DS")
                            TextField("학생증 코드", text: $temporaryCode)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray)
                                }
                                .keyboardType(.numberPad)
                                .onChange(of: temporaryCode, { oldValue, newValue in
                                    if newValue.count > 5 {
                                        temporaryCode = String(newValue.prefix(5))
                                    }
                                })
                                .onSubmit {
                                    validateCode()
                                }
                        }
                        if !isValid {
                            Text("학생증 코드는 5자리 숫자여야 합니다.")
                                .foregroundStyle(.red)
                        } else {
                            Text("학생증 코드는 5자리 숫자여야 합니다.")
                                .foregroundStyle(.background)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
                Button {
                    validateCode()
                    if isValid {
                        inputCode = "DS" + temporaryCode
                        UserDefaults.standard.set(inputCode, forKey: "savedCode")
                        isShowing = false
                        HapticManager.instance.notification(notificationType: .success)
                    }
                } label: {
                    Text("계속")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
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
            .frame(maxWidth: 450)
        }
    }
    
    private func validateCode() {
        if temporaryCode.count == 5 && temporaryCode.allSatisfy(\.isNumber) {
            isValid = true
        } else {
            isValid = false
        }
    }
}

#Preview {
    BarcodeView()
}
