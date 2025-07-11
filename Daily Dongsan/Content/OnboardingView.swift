//
//  OnboardingView.swift
//  geubchelin
//
//  Created by 최지한 on 1/25/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("데일리 동산 시작하기")
                    .font(.system(.largeTitle, weight: .bold))
                    .padding(.top, 100)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    FeatureItemView(
                        image: "house.fill",
                        title: "오늘의 급식",
                        description: "홈 화면에서 오늘의 급식을 빠르게 확인하세요."
                    )
                    FeatureItemView(
                        image: "calendar",
                        title: "캘린더로 보기",
                        description: "캘린더를 통해 원하는 날짜의 급식을 확인하세요."
                    )
                    FeatureItemView(
                        image: "allergens.fill",
                        title: "알레르기 유발 식품 경고",
                        description: "알레르기 유발 식품을 설정하면 해당 음식이 빨간색으로 표시됩니다."
                    )
                }
                .padding(.horizontal)
                NavigationLink {
                    AllergySelectionView()
                } label: {
                    Text("알레르기 유발 식품 선택")
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                NavigationLink {
                    ZStack {
                        BarcodeSetupView()
                        VStack {
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                Text("지금 안 함")
                                    .fontWeight(.semibold)
                            }
                            .padding(.bottom)
                            .padding(.bottom)
                        }
                    }
                } label: {
                    Text("계속")
                        .fontWeight(.semibold)
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
    
    @ViewBuilder
    private func FeatureItemView(image: String, title: String, description: String) -> some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.accent)
                .frame(width: 45, height: 45)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    OnboardingView()
}
