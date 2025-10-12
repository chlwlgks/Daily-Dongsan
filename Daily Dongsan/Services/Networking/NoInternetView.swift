//
//  NoInternetView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 5/5/25.
//

import SwiftUI

struct NoInternetView: View {
    private let symbols = ["wifi.slash", "antenna.radiowaves.left.and.right.slash"]
    
    var body: some View {
        HStack {
            TimelineView(.periodic(from: .now, by: 2)) { context in
                let index = Int(context.date.timeIntervalSinceReferenceDate / 2) % symbols.count
                ZStack {
                    ForEach(symbols.indices, id: \.self) { i in
                        if i == index {
                            Image(systemName: symbols[i])
                                .transition(.blurReplace)
                        }
                    }
                }
                .frame(width: 20, height: 20)
                .animation(.easeInOut, value: index)
            }
            Text("인터넷 연결 없음")
        }
        .font(.subheadline)
        .foregroundStyle(.white)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background(.black)
    }
}

#Preview {
    NoInternetView()
}
