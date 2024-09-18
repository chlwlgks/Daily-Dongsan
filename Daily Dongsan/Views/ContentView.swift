//
//  ContentView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView() {
            Tab("홈", systemImage: "house") {
                HomeView()
            }
            Tab("식단", systemImage: "fork.knife") {
                MealsView()
            }
            Tab("학생증", systemImage: "person.text.rectangle") {
                Text("학생증")
            }
            Tab("설정", systemImage: "gearshape") {
                Text("설정")
            }
        }
        .tabViewStyle(.tabBarOnly) // sidebar가 필요할까??
    }
}

#Preview {
    ContentView()
        .environmentObject(MealService())
}
