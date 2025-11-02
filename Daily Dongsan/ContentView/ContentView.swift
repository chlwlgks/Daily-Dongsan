//
//  ContentView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI

private enum AppTab: String, CaseIterable {
    case home = "홈"
    case calendar = "캘린더"
    case timetable = "시간표"
    case studentID = "학생증"
    case more = "더보기"
    
    var systemImage: String {
        switch self {
        case .home: return "house"
        case .calendar: return "calendar"
        case .timetable: return "clock"
        case .studentID: return "person.text.rectangle"
        case .more: return "ellipsis"
        }
    }
    
    @ViewBuilder var view: some View {
        switch self {
        case .home: HomeView()
        case .calendar: CalendarView()
        case .timetable: TimetableView()
        case .studentID: StudentIDView()
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
                ForEach(AppTab.allCases, id: \.rawValue) { tab in
                    Tab(tab.rawValue, systemImage: tab.systemImage, value: tab) {
                        tab.view
                    }
                }
            }
            .tabViewStyle(.sidebarAdaptable)
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

#Preview {
    ContentView()
}

