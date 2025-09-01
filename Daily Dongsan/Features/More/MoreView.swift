//
//  SettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/13/24.
//

import SwiftUI

struct MoreView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("breakfastNotificationEnabled") var breakfastNotificationEnabled: Bool = false
    @AppStorage("lunchNotificationEnabled") var lunchNotificationEnabled: Bool = false
    @AppStorage("dinnerNotificationEnabled") var dinnerNotificationEnabled: Bool = false
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        HStack {
                            Text("알림")
                            Spacer()
                            if breakfastNotificationEnabled || lunchNotificationEnabled || dinnerNotificationEnabled {
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
                    NavigationLink("알레르기 유발 식품 선택") {
                        AllergySelectionView()
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
                    Text("버전: \(appVersion)")
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
