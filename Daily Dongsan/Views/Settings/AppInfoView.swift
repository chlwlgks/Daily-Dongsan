//
//  AppInfoView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/16/24.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("데일리 동산")
                    .font(.largeTitle)
            }
            .navigationTitle("앱 정보")
        }
    }
}

#Preview {
    AppInfoView()
}
