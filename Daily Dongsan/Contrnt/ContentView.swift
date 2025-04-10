//
//  ContentView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        if #available(iOS 18, *) {
            TabView() {
                Tab("홈", systemImage: "house") {
                    HomeView()
                }
                Tab("식단", systemImage: "calendar") {
                    MealPlanView()
                }
                Tab("학생증", systemImage: "person.text.rectangle") {
                    BarcodeView()
                }
                Tab("더보기", systemImage: "ellipsis") {
                    MoreView()
                }
            }
            .tabViewStyle(.sidebarAdaptable)
        } else {
            Group {
                if horizontalSizeClass == .regular {
                    NavigationSplitView {
                        List {
                            NavigationLink {
                                HomeView()
                            } label: {
                                Label("홈", systemImage: "house")
                            }
                            NavigationLink {
                                MealPlanView()
                            } label: {
                                Label("식단", systemImage: "calendar")
                            }
                            NavigationLink {
                                BarcodeView()
                            } label: {
                                Label("학생증", systemImage: "person.text.rectangle")
                            }
                        }
                    } detail: {
                        HomeView()
                    }
                } else {
                    TabView() {
                        HomeView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("홈")
                            }
                        MealPlanView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("식단")
                            }
                        BarcodeView()
                            .tabItem {
                                Image(systemName: "person.text.rectangle")
                                Text("학생증")
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
