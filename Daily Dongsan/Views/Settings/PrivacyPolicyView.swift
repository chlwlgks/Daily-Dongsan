//
//  PrivacyPolicyView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/16/24.
//

import SwiftUI
import SafariServices

struct PrivacyPolicyView: View {
    var body: some View {
        WebPrivacyPolicyView()
    }
}

struct WebPrivacyPolicyView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let myURL = URL(string: "https://resilient-griffin-db764c.netlify.app")
        return SFSafariViewController(url: myURL!)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

#Preview {
    PrivacyPolicyView()
}
