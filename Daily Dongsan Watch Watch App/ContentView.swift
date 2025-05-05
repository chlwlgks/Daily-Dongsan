//
//  ContentView.swift
//  Daily Dongsan Watch Watch App
//
//  Created by 최지한 on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "fork.knife")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Coming Soon...")
            TextField("", text: .constant(""))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
