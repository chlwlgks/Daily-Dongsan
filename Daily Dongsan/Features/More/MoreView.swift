//
//  SettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/13/24.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var notificationSettingsViewModel =  NotificationSettingsViewModel()
    @AppStorage("breakfastNotificationEnabled") var breakfastNotificationEnabled = false
    @AppStorage("lunchNotificationEnabled") var lunchNotificationEnabled = false
    @AppStorage("dinnerNotificationEnabled") var dinnerNotificationEnabled = false
    
    @AppStorage("showNextDayAfter7PM") var showNextDayAfter7PM = true
    @AppStorage("skipWeekends") var skipWeekends = true
    
    @StateObject private var allergySelectionViewModel = AllergySelectionViewModel()
    
    @AppStorage("studentID") var studentID: String?
    @State private var showResetIDConfirmation = false
    
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("데일리 동산을 물려받을 후배를 찾아요.\nDM: @j12han") {
                        UIApplication.shared.open(URL(string: "https://www.instagram.com/j12han/")!)
                    }
                }
                
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                            .environmentObject(notificationSettingsViewModel)
                    } label: {
                        LabeledContent("알림") {
                            if notificationSettingsViewModel.notificationAuthorizationStatus == .authorized && (breakfastNotificationEnabled || lunchNotificationEnabled || dinnerNotificationEnabled) {
                                Text("켬")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("끔")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } footer: {
                    Text("알림은 평일에만 전송됩니다.")
                }
                
                Section {
                    Toggle("19시 이후 다음날 급식 표시", isOn: $showNextDayAfter7PM)
                    Toggle("주말 건너뛰기", isOn: $skipWeekends)
                }
                
                Section {
                    NavigationLink {
                        AllergySelectionView()
                            .environmentObject(allergySelectionViewModel)
                    } label: {
                        LabeledContent("알레르기 유발 식품 선택") {
                            if !allergySelectionViewModel.selectedAllergies.isEmpty {
                                Text("\(allergySelectionViewModel.selectedAllergies.count)개")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    Button("학생증 재설정") {
                        showResetIDConfirmation = true
                    }
                    .alert("학생증 재설정", isPresented: $showResetIDConfirmation) {
                        Button("취소", role: .cancel) { }
                        Button("학생증 재설정", role: .destructive) {
                            studentID = nil
                            HapticManager.instance.notification(notificationType: .success)
                        }
                    } message: {
                        Text("학생증 도용 시 안산동산고등학교 학생 생활 교육규정 제12조에 따라 학생 생활교육을 받을 수 있습니다.")
                    }
                }
                
                //                Section {
                //                    NavigationLink {
                //                        Text("흐흐흐")
                //                    } label: {
                //                        Text("하이라이트한 급식")
                //                    }
                //                }
                
                Section {
                    NavigationLink("피드백 공유") {
                        FeedbackShareView()
                    }
                } footer: {
                    Text("버전: " + String(describing: appVersion))
                }
                
                //                Button("워치 업데이트") {
                //                    WatchConnector().session.sendMessage(["message" : "메시지 보냄"], replyHandler: nil)
                //                }
            }
            .navigationTitle("더보기")
        }
    }
}

#Preview {
    MoreView()
}
