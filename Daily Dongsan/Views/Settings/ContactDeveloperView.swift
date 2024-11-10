//
//  ContactDeveloperView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import SwiftUI

struct ContactDeveloperView: View {
    private let InstagramURL1 = "https://www.instagram.com/ellio__ot/"
    private let InstagramURL2 = "https://www.instagram.com/j1hxna/"
    
    var body: some View {
        NavigationStack {
            Form {
                Button {
                    if let url = URL(string: InstagramURL1) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text("김병윤: ellio__ot")
                        Spacer()
                        Image(systemName: "link")
                            .foregroundStyle(.gray)
                    }
                }
                Button {
                    if let url = URL(string: InstagramURL2) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text("최지한: j1hxna")
                        Spacer()
                        Image(systemName: "link")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("개발자에게 문의하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContactDeveloperView()
}
