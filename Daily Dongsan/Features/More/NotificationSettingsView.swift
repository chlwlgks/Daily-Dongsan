//
//  NotificationSettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/16/24.
//

import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel =  NotificationSettingsViewModel()
    
    var body: some View {
        Form {
            if viewModel.notificationAuthorizationStatus != .authorized && viewModel.notificationAuthorizationStatus != .provisional {
                Section {
                    VStack {
                        Text("데일리 동산의 알림이 허용되어 있지 않습니다.")
                            .foregroundStyle(.red)
                        Button("설정에서 권한 허용하기") {
                            let url = URL(string: "app-settings:notifications")!
                            openURL(url)
                        }
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                }
            }
            
            Group {
                Section {
                    Toggle(isOn: $viewModel.breakfastNotificationEnabled) {
                        Text("조식 알림")
                    }
                    DatePicker("시간", selection: $viewModel.breakfastNotificationTime, displayedComponents: .hourAndMinute)
                }
                Section {
                    Toggle(isOn: $viewModel.lunchNotificationEnabled) {
                        Text("중식 알림")
                    }
                    DatePicker("시간", selection: $viewModel.lunchNotificationTime, displayedComponents: .hourAndMinute)
                }
                Section {
                    Toggle(isOn: $viewModel.dinnerNotificationEnabled) {
                        Text("석식 알림")
                    }
                    DatePicker("시간", selection: $viewModel.dinnerNotificationTime, displayedComponents: .hourAndMinute)
                }
            }
            .disabled(viewModel.notificationAuthorizationStatus != .authorized && viewModel.notificationAuthorizationStatus != .provisional)
            
            Section {
                NavigationLink {
                    ResetNotificationsView(viewModel: viewModel)
                } label: {
                    Text("'🍽️'이 포함된 알림이 오는 경우")
                }
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.fetchAuthorizationStatus()
            }
        }
    }
}

struct ResetNotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NotificationSettingsViewModel

    var body: some View {
        Form {
            Section {
                VStack {
                    Text("""
                    일부 기기에서 '🍽️' 이모티콘이 포함된 이전 버전의 알림이 오는 오류가 확인됐습니다.
                    이전 버전의 알림이 올 때에는 버튼을 눌러 알림을 초기화해 주세요.
                    '🍴, 🍛, 😋' 이모티콘이 포함된 알림은 해당 사항이 없습니다.
                    """)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            Section {
                Button("알림 초기화") {
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    
                    viewModel.breakfastNotificationEnabled = false
                    viewModel.breakfastNotificationTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
                    viewModel.lunchNotificationEnabled = false
                    viewModel.lunchNotificationTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
                    viewModel.dinnerNotificationEnabled = false
                    viewModel.dinnerNotificationTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
                    
                    dismiss()
                    HapticManager.instance.notification(notificationType: .success)
                }
            }
        }
        .navigationTitle("'🍽️'이 포함된 알림이 오는 경우")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotificationSettingsView()
}
