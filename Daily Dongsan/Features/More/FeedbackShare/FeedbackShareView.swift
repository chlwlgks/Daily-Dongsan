//
//  ContactDeveloperView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import SwiftUI

struct FeedbackShareView: View {
    var body: some View {
        List {
            Section("Instagram") {
                Button {
                    UIApplication.shared.open(URL(string: "https://www.instagram.com/ellio__ot/")!)
                } label: {
                    Text("김병윤: ellio__ot")
                }
                Button {
                    UIApplication.shared.open(URL(string: "https://www.instagram.com/j1hxna/")!)
                } label: {
                    Text("최지한: j1hxna")
                }
            }
            
            if MailComposeViewController.canSendMail {
                Section("Mail") {
                    Button {
                        MailComposeViewController.shared.sendEmail()
                    } label: {
                        Text("Mail")
                    }
                }
            }
        }
        .navigationTitle("피드백 공유")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FeedbackShareView()
}
