//
//  StudentIDSetupView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/10/25.
//

import SwiftUI

struct StudentIDSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("studentID") private var studentID: String?
    
    @State private var input = ""
    @FocusState private var isFocused: Bool
    @State private var didConfirm = false
    
    private func commit() {
        if !input.isEmpty {
            didConfirm = true
            dismiss()
            HapticManager.instance.notification(notificationType: .success)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("학생증 시작하기")
                    .font(.title2.weight(.bold))
                
                Text("학생증 사진 아래에 있는 5자리 코드를 입력하세요.")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                VStack {
                    TextField("학생증 코드", text: $input)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($isFocused)
                        .onChange(of: input) { newValue in
                            input = newValue.uppercased()
                        }
                        .onSubmit {
                            commit()
                        }
                }
                
                Spacer()
                
                Text("학생증 도용 시 안산동산고등학교 학생 생활 교육규정 제12조에 따라 학생 생활교육을 받을 수 있습니다.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    commit()
                } label: {
                    Text("완료")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .buttonStyle(.borderedProminent)
                .disabled(input.isEmpty)
                .padding(.bottom)
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .padding(.horizontal)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("취소", systemImage: "xmark")
                }
            }
            .onAppear {
                isFocused = true
            }
            .onDisappear {
                if didConfirm {
                    studentID = input
                }
            }
        }
    }
}

#Preview {
    StudentIDSetupView()
}
