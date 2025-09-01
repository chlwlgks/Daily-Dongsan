//
//  BarcodeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/10/24.
//

import SwiftUI
import SwiftData

struct BarcodeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("studentID") private var studentID: String?
    
    @StateObject private var viewModel = BarcodeViewModel()
    
    @State private var isShowingBarcodeSetupView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let studentID {
                    GeometryReader { geometry in
                        let barwidth = horizontalSizeClass == .regular ? (370 / 130) : (geometry.size.width / 130)
                        let barheight = barwidth * 35
                        
                        VStack {
                            HStack(spacing: 0) {
                                ForEach(Array(viewModel.generateCode39(from: studentID)), id: \.self) { bar in
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
                            
                            Text(studentID)
                            
                            Text("학생증 도용 시 안산동산고등학교 학생 생활 교육규정 제12조에 따라 학생 생활교육을 받을 수 있습니다.")
                                .multilineTextAlignment(.center)
                                .padding(.top)
                                .padding(.top)
                                .padding(.top)
                            Text("1학년은 학생증 바코드가 제대로 동작하지 않을 수 있습니다.")
                                .multilineTextAlignment(.center)
                                .padding(.top)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding()
                } else {
                    Button {
                        isShowingBarcodeSetupView = true
                    } label: {
                        Text("학생증 시작하기")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("학생증")
        }
        .task {
            if studentID == nil {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    isShowingBarcodeSetupView = true
                }
            }
        }
        .sheet(isPresented: $isShowingBarcodeSetupView) {
            NavigationStack {
                BarcodeSetupView()
                    .toolbar {
                        Button("취소") {
                            isShowingBarcodeSetupView = false
                        }
                    }
            }
        }
    }
}
    
    #Preview {
        BarcodeView()
    }
