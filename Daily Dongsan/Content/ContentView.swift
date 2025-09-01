//
//  ContentView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import SwiftData

enum AppTab: String, CaseIterable {
    case home = "홈"
    case mealPlan = "식단"
    case timetable = "시간표"
    case barcode = "학생증"
    case more = "더보기"
    
    var systemImage: String {
        switch self {
        case .home: return "house"
        case .mealPlan: return "calendar"
        case .timetable: return "clock"
        case .barcode: return "person.text.rectangle"
        case .more: return "ellipsis"
        }
    }
    
    @ViewBuilder var view: some View {
        switch self {
        case .home: HomeView()
        case .mealPlan: MealPlanView()
//        case .timetable: TimetableView()
        case .timetable: Text("Coming Soon")
        case .barcode: BarcodeView()
        case .more: MoreView()
        }
    }
}

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var selection: AppTab? = .home
    
    var body: some View {
        if #available(iOS 18, *) {
            TabView(selection: $selection) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Tab(tab.rawValue, systemImage: tab.systemImage, value: tab) {
                        tab.view
                    }
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .tabViewSidebarHeader {
                HStack {
                    Text("데일리 동산")
                        .font(.system(.largeTitle, weight: .bold))
                    Spacer()
                }
            }
        } else {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    List(AppTab.allCases, id: \.self, selection: $selection) { tab in
                        Label(tab.rawValue, systemImage: tab.systemImage)
                    }
                    .navigationTitle("데일리 동산")
                } detail: {
                    switch selection! {
                    case .home:
                        HomeView()
                    case .mealPlan:
                        MealPlanView()
                    case.timetable:
                        TimetableView()
                    case .barcode:
                        BarcodeView()
                    case .more:
                        MoreView()
                    }
                }
            } else {
                TabView(selection: $selection) {
                    ForEach(AppTab.allCases, id: \.self) { tab in
                        tab.view
                            .tabItem {
                                Image(systemName: tab.systemImage)
                                Text(tab.rawValue)
                            }
                            .tag(tab)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
