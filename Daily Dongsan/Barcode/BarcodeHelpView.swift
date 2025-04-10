//
//  BarcodeHelpView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/11/25.
//

import SwiftUI

struct BarcodeHelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("코드를 변경하고 싶어요.")
                        .font(.headline)
                    Text("학생증 코드는 개발자에게 문의해야만 변경할 수 있습니다.")
                    
                    Divider()
                    
                    Text("바코드 인식이 안 될 경우")
                        .font(.headline)
                    Text("· 밝기를 올려 주세요.")
                    Text("· 바코드를 가까이 대주세요.")
                }
                .padding()
            }
            .navigationTitle("학생증 도움말")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("완료")
                }
                
            }
        }
    }
}

#Preview {
    BarcodeHelpView()
}
