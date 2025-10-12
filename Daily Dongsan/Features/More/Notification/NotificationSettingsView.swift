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
    
    @Environment(NotificationSettingsViewModel.self) private var viewModel
    
    @State private var showResetAlert: Bool = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        Form {
            if viewModel.notificationAuthorizationStatus != .authorized {
                Section {
                    VStack(alignment: .leading) {
                        Text("데일리 동산의 알림이 허용되어 있지 않습니다.")
                            .foregroundStyle(.red)
                        Button("설정에서 권한 허용하기") {
                            let url = URL(string: UIApplication.openNotificationSettingsURLString)!
                            openURL(url)
                        }
                    }
                }
            }
            
            Group {
                Section {
                    Toggle("조식 알림", isOn: $viewModel.breakfastNotificationEnabled)
                    DatePicker("시간", selection: $viewModel.breakfastNotificationTime, displayedComponents: .hourAndMinute)
                }
                Section {
                    Toggle("중식 알림", isOn: $viewModel.lunchNotificationEnabled)
                    DatePicker("시간", selection: $viewModel.lunchNotificationTime, displayedComponents: .hourAndMinute)
                }
                Section {
                    Toggle("석식 알림", isOn: $viewModel.dinnerNotificationEnabled)
                    DatePicker("시간", selection: $viewModel.dinnerNotificationTime, displayedComponents: .hourAndMinute)
                }
            }
            .disabled(viewModel.notificationAuthorizationStatus != .authorized)
            
            Section {
                Button("알림 재설정") {
                    showResetAlert = true
                }
                .alert("알림 재설정", isPresented: $showResetAlert) {
                    Button("취소", role: .cancel) {}
                    Button("알림 재설정", role: .destructive, action: performReset)
                } message: {
                    Text("이 작업은 알림 설정을 초기 설정으로 재설정합니다.")
                }
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: scenePhase) {
            guard scenePhase == .active else { return }
            viewModel.requestAuthorizationIfNeeded()
        }
    }
    
    private func performReset() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        viewModel.breakfastNotificationEnabled = false
        viewModel.breakfastNotificationTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        viewModel.lunchNotificationEnabled = false
        viewModel.lunchNotificationTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        viewModel.dinnerNotificationEnabled = false
        viewModel.dinnerNotificationTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!

        HapticManager.instance.notification(notificationType: .success)
    }
}

#Preview {
    NotificationSettingsView()
}
