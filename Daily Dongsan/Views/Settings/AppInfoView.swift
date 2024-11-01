//
//  AppInfoView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/16/24.
//

import SwiftUI

struct AppInfoView: View {
    let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("Daily_Dongsan")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding()
                
                Text("데일리 동산")
                    .font(.system(.largeTitle, weight: .bold))
                
                Text("버전 \(version)")
                
                Text("© 2024 김병윤, 최지한. 모든 권리 보유.")
                
                Spacer()
            }
            .padding()
            .navigationTitle("앱 정보")
        }
    }
}

#Preview {
    AppInfoView()
}
