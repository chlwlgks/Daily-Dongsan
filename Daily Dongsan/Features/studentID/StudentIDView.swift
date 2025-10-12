//
//  StudentIDView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/10/24.
//

import SwiftUI
import SwiftData

struct BarcodeView: View {
    @Environment(StudentIDViewModel.self) private var viewModel
    
    let content: String
    
    var body: some View {
        Canvas { context, size in
            let prefixSuffixCount = 2
            let characterCount = content.count + prefixSuffixCount
            let gapCount = content.count + 1
            
            let characterUnits = 15
            let totalUnits = (characterCount * characterUnits) + gapCount
            
            let narrowBarWidth = size.width / CGFloat(totalUnits)
            
            var currentX: CGFloat = 0
            for (index, module) in viewModel.generateCode39(from: content).enumerated() {
                var barPath = Path()
                let bartWidth = module == .narrow ? narrowBarWidth : narrowBarWidth * 3
                let barRect = CGRect(x: currentX, y: 0, width: bartWidth, height: size.height)
                barPath.addRect(barRect)
                
                let barColor: Color = (index % 2) == 0 ? .black : .white
                
                context.fill(barPath, with: .color(barColor))
                
                currentX += bartWidth
            }
        }
    }
}

struct StudentIDView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("studentID") private var studentID: String?
    
    @State private var viewModel = StudentIDViewModel()
    
    @State private var isShowingBarcodeSetupView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let studentID {
                    Group {
                        BarcodeView(content: studentID)
                            .environment(viewModel)
                            .applyIf(horizontalSizeClass == .regular) { view in
                                view.frame(width: 370, height: 370 / 3)
                            }
                            .aspectRatio(3, contentMode: .fit)
                            .applyIf(colorScheme == .dark) { view in
                                view.padding()
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        
                        Text(studentID)
                    }
                    .privacySensitive()
                    
                    Text("학생증 도용 시 안산동산고등학교 학생 생활 교육규정 제12조에 따라 학생 생활교육을 받을 수 있습니다.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                } else {
                    Button {
                        isShowingBarcodeSetupView = true
                    } label: {
                        Text("학생증 시작하기")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $isShowingBarcodeSetupView) {
                        StudentIDSetupView()
                            .presentationDetents([.medium])
                    }
                }
            }
            .animation(.default, value: studentID)
            .navigationTitle("학생증")
            .scenePadding()
        }
        .onAppear {
            DispatchQueue.main.async {
                isShowingBarcodeSetupView = !(studentID != nil)
            }
        }
    }
}

#Preview {
    StudentIDView()
}
