//
//  BarcodeSetupView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/10/25.
//

import SwiftUI

struct BarcodeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("studentID") private var studentID: String?
    
    @StateObject private var viewModel = BarcodeViewModel()
    
    @State private var input: String = ""
    
    var body: some View {
        VStack {
            Text("학생증 시작하기")
                .font(.system(.largeTitle, weight: .bold))
                .padding(.top, 50)
            
            Spacer()
            
            Text("학생증 도용 시 안산동산고등학교 학생 생활 교육규정 제12조에 따라 학생 생활교육을 받을 수 있습니다.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack {
                HStack {
                    Text("DS")
                        .padding(.trailing)
                    TextField("학생증 코드", text: $input)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary)
                        }
                        .keyboardType(.numberPad)
                        .onChange(of: input) { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            input = String(filtered.prefix(5))
                        }
                        .onSubmit {
                            viewModel.validateCode(code: input)
                        }
                }
                Text("학생증 코드는 5자리 숫자여야 합니다.")
                    .foregroundStyle(.red)
                    .opacity(viewModel.isValid ? 0 : 1)
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
            
            Button {
                viewModel.validateCode(code: input)
                if viewModel.isValid {
                    studentID = "DS" + input
                    dismiss()
                    HapticManager().notification(notificationType: .success)
                }
            } label: {
                Text("완료")
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 35)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
            .padding(.bottom)
            .padding(.bottom)
            .padding(.bottom)
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }
}

#Preview {
    BarcodeSetupView()
}
