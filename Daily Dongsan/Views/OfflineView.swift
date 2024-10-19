//
//  OfflineView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import SwiftUI

struct OfflineView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(maxWidth: 57.5, maxHeight: 57.5)
                .padding()
            
            Text("인터넷 연결 없음")
                .font(.title2)
                .bold()
            Text("데일리 동산 앱이 인터넷에 연결되어 있지 않습니다. 연결하려면 에어플레인 모드를 끄거나 Wi-Fi 네트워크에 연결하십시오.")
                .font(.callout)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            
            Button {
                UIApplication.shared.open(URL(string: "App-Prefs:WIFI")!)
            } label: {
                Text("설정으로 이동")
            }
            .font(.callout)
            .padding()
        }
        .padding(.horizontal)
        .frame(maxWidth: 375)
    }
}

#Preview {
    OfflineView()
}
