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
    @State private var tabsShowingBadge: Set<AppTab> = []
    @State private var didInitBadges = false
    private func initializeBadgesIfNeeded() {
        guard !didInitBadges else { return }
        didInitBadges = true
        var set: Set<AppTab> = []
//        if !calendarBadgeDismissed { set.insert(.calendar) }
        if !timetableBadgeDismissed { set.insert(.timetable) }
        if !studentIDBadgeDismissed { set.insert(.studentID) }
        if !moreBadgeDismissed { set.insert(.more) }
        tabsShowingBadge = set
    }
    
//    @AppStorage("badge.calendar.dismissed") private var calendarBadgeDismissed = false
    @AppStorage("badge.timetable.dismissed") private var timetableBadgeDismissed = false
    @AppStorage("badge.studentID.dismissed") private var studentIDBadgeDismissed = false
    @AppStorage("badge.more.dismissed") private var moreBadgeDismissed = false
    
    var body: some View {
        if #available(iOS 18.0, *) {
            TabView(selection: $selection) {
                ForEach(AppTab.allCases, id: \.rawValue) { tab in
                    Tab(tab.rawValue, systemImage: tab.systemImage, value: tab) {
                        tab.view
                    }
                    .badge(tabsShowingBadge.contains(tab) ? Text("new") : nil)
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .task { initializeBadgesIfNeeded() }
            .onChange(of: selection) { _, newValue in
                guard let tab = newValue else { return }
                switch tab {
//                case .calendar:
//                    if tabsShowingBadge.contains(.calendar) { tabsShowingBadge.remove(.calendar) }
//                    if !calendarBadgeDismissed { calendarBadgeDismissed = true }
                case .timetable:
                    if tabsShowingBadge.contains(.timetable) { tabsShowingBadge.remove(.timetable) }
                    if !timetableBadgeDismissed { timetableBadgeDismissed = true }
                case .studentID:
                    if tabsShowingBadge.contains(.studentID) { tabsShowingBadge.remove(.studentID) }
                    if !studentIDBadgeDismissed { studentIDBadgeDismissed = true }
                case .more:
                    if tabsShowingBadge.contains(.more) { tabsShowingBadge.remove(.more) }
                    if !moreBadgeDismissed { moreBadgeDismissed = true }
                default:
                    break
                }
            }
        } else {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    List(AppTab.allCases, id: \.rawValue, selection: $selection) { tab in
                        HStack {
                            Label(tab.rawValue, systemImage: tab.systemImage)
                            Spacer()
                            if tabsShowingBadge.contains(tab) {
                                Text("new")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .navigationTitle("데일리 동산")
                } detail: {
                    switch selection! {
                    case .home:
                        HomeView()
                    case .calendar:
                        CalendarView()
                    case.timetable:
                        TimetableView()
                    case .studentID:
                        StudentIDView()
                    case .more:
                        MoreView()
                    }
                }
                .task { initializeBadgesIfNeeded() }
                .onChange(of: selection) { _, newValue in
                    guard let tab = newValue else { return }
                    switch tab {
//                    case .calendar:
//                        if tabsShowingBadge.contains(.calendar) { tabsShowingBadge.remove(.calendar) }
//                        if !calendarBadgeDismissed { calendarBadgeDismissed = true }
                    case .timetable:
                        if tabsShowingBadge.contains(.timetable) { tabsShowingBadge.remove(.timetable) }
                        if !timetableBadgeDismissed { timetableBadgeDismissed = true }
                    case .studentID:
                        if tabsShowingBadge.contains(.studentID) { tabsShowingBadge.remove(.studentID) }
                        if !studentIDBadgeDismissed { studentIDBadgeDismissed = true }
                    case .more:
                        if tabsShowingBadge.contains(.more) { tabsShowingBadge.remove(.more) }
                        if !moreBadgeDismissed { moreBadgeDismissed = true }
                    default:
                        break
                    }
                }
            } else {
                TabView(selection: $selection) {
                    ForEach(AppTab.allCases, id: \.rawValue) { tab in
                        tab.view
                            .tabItem {
                                Image(systemName: tab.systemImage)
                                Text(tab.rawValue)
                            }
                            .tag(tab)
                            .badge(tabsShowingBadge.contains(tab) ? "new" : nil)
                    }
                }
                .task { initializeBadgesIfNeeded() }
                .onChange(of: selection) { _, newValue in
                    guard let tab = newValue else { return }
                    switch tab {
//                    case .calendar:
//                        if tabsShowingBadge.contains(.calendar) { tabsShowingBadge.remove(.calendar) }
//                        if !calendarBadgeDismissed { calendarBadgeDismissed = true }
                    case .timetable:
                        if tabsShowingBadge.contains(.timetable) { tabsShowingBadge.remove(.timetable) }
                        if !timetableBadgeDismissed { timetableBadgeDismissed = true }
                    case .studentID:
                        if tabsShowingBadge.contains(.studentID) { tabsShowingBadge.remove(.studentID) }
                        if !studentIDBadgeDismissed { studentIDBadgeDismissed = true }
                    case .more:
                        if tabsShowingBadge.contains(.more) { tabsShowingBadge.remove(.more) }
                        if !moreBadgeDismissed { moreBadgeDismissed = true }
                    default:
                        break
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

