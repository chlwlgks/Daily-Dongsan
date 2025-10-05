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
    
    @AppStorage("badge.calendar.dismissed") private var calendarBadgeDismissed = false
    @AppStorage("badge.timetable.dismissed") private var timetableBadgeDismissed = false
    @AppStorage("badge.studentID.dismissed") private var studentIDBadgeDismissed = false
    @AppStorage("badge.more.dismissed") private var moreBadgeDismissed = false
    private func shouldShowBadge(for tab: AppTab) -> Bool {
        switch tab {
        case .calendar:
            return !calendarBadgeDismissed
        case .timetable:
            return !timetableBadgeDismissed
        case .studentID:
            return !studentIDBadgeDismissed
        case .more:
            return !moreBadgeDismissed
        default:
            return false
        }
    }
    
    var body: some View {
        if #available(iOS 18.0, *) {
            TabView(selection: $selection) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Tab(tab.rawValue, systemImage: tab.systemImage, value: tab) {
                        tab.view
                    }
                    .badge(shouldShowBadge(for: tab) ? Text("new") : nil)
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .onChange(of: selection) { newValue in
                guard let tab = newValue else { return }
                switch tab {
                case .calendar:
                    calendarBadgeDismissed = true
                case .timetable:
                    timetableBadgeDismissed = true
                case .studentID:
                    studentIDBadgeDismissed = true
                case .more:
                    moreBadgeDismissed = true
                default:
                    break
                }
            }
        } else {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    List(AppTab.allCases, id: \.self, selection: $selection) { tab in
                        HStack {
                            Label(tab.rawValue, systemImage: tab.systemImage)
                            Spacer()
                            if shouldShowBadge(for: tab) {
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
                .onChange(of: selection) { newValue in
                    guard let tab = newValue else { return }
                    switch tab {
                    case .calendar:
                        calendarBadgeDismissed = true
                    case .timetable:
                        timetableBadgeDismissed = true
                    case .studentID:
                        studentIDBadgeDismissed = true
                    case .more:
                        moreBadgeDismissed = true
                    default:
                        break
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
                            .badge(shouldShowBadge(for: tab) ? Text("new") : nil)
                    }
                }
                .onChange(of: selection) { newValue in
                    guard let tab = newValue else { return }
                    switch tab {
                    case .calendar:
                        calendarBadgeDismissed = true
                    case .timetable:
                        timetableBadgeDismissed = true
                    case .studentID:
                        studentIDBadgeDismissed = true
                    case .more:
                        moreBadgeDismissed = true
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
