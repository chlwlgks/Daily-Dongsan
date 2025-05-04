//
//  SettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/13/24.
//

import SwiftUI

struct MoreView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
//    @State private var breakfastNotification: Bool = UserDefaults.standard.bool(forKey: "breakfastNotification")
//    @State private var lunchNotification: Bool = UserDefaults.standard.bool(forKey: "lunchNotification")
//    @State private var dinnerNotification: Bool = UserDefaults.standard.bool(forKey: "dinnerNotification")
    
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    
    var body: some View {
        NavigationStack {
            List {
//                Section {
//                    NavigationLink {
//                        NotificationSettingsView()
//                    } label: {
//                        HStack {
//                            Label {
//                                Text("알림")
//                            } icon: {
//                                IconView(foregroundStyle: Color.red, systemImage: "bell.badge.fill")
//                            }
//                            Spacer()
//                            if breakfastNotification || lunchNotification || dinnerNotification {
//                                Text("켬")
//                                    .foregroundStyle(.secondary)
//                            } else {
//                                Text("끔")
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                    }
//                }
                
                Section {
                    NavigationLink {
                        AllergySelectionView()
                    } label: {
                        Text("알레르기 유발 식품 선택")
                    }
                }
                
                Section {
                    NavigationLink {
                        FeedbackShareView()
                    } label: {
                        Text("피드백 공유")
                    }
                } footer: {
                    Text("버전: \(appVersion)")
                }
            }
            .navigationTitle("더보기")
//            .onAppear {
//                breakfastNotification = UserDefaults.standard.bool(forKey: "breakfastNotification")
//                lunchNotification = UserDefaults.standard.bool(forKey: "lunchNotification")
//                dinnerNotification = UserDefaults.standard.bool(forKey: "dinnerNotification")
//            }
        }
    }
}

#Preview {
    MoreView()
}
