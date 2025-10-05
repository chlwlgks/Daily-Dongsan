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
                Link("최지한: j12han", destination: URL(string: "https://www.instagram.com/j12han/")!)
                Link("김병윤: ellio__ot", destination: URL(string: "https://www.instagram.com/ellio__ot/")!)
            }
            
            if MailComposeViewController.canSendMail {
                Section("Mail") {
                    Button("Mail") {
                        MailComposeViewController.shared.sendEmail()
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
