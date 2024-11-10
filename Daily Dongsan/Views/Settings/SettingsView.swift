//
//  SettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/13/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var breakfastNotification: Bool = UserDefaults.standard.bool(forKey: "breakfastNotification")
    @State private var lunchNotification: Bool = UserDefaults.standard.bool(forKey: "lunchNotification")
    @State private var dinnerNotification: Bool = UserDefaults.standard.bool(forKey: "dinnerNotification")
    
    @State private var isShowingPrivacyPolicyView: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        HStack {
                            Label {
                                Text("알림")
                            } icon: {
                                IconView(foregroundStyle: Color.red, systemImage: "bell.badge.fill")
                            }
                            Spacer()
                            if breakfastNotification || lunchNotification || dinnerNotification {
                                Text("켬")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("끔")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        isShowingPrivacyPolicyView = true
                    } label: {
                        Label {
                            Text("개인정보 처리방침")
                        } icon: {
                            if #available(iOS 18, *) {
                                IconView(foregroundStyle: Color.gray, systemImage: "text.page.fill")
                            } else {
                                IconView(foregroundStyle: Color.gray, systemImage: "text.book.closed.fill")
                            }
                        }
                    }
                    
                    NavigationLink {
                        ContactDeveloperView()
                    } label: {
                        Label {
                            Text("개발자에게 문의하기")
                        } icon: {
                            IconView(foregroundStyle: Color.gray, systemImage: "message.fill")
                        }
                    }
                    
                    NavigationLink {
                        AppInfoView()
                    } label: {
                        Label {
                            Text("앱 정보")
                        } icon: {
                            IconView(foregroundStyle: Color.gray, systemImage: "info.circle.fill")
                        }
                    }
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("완료")
                }
            }
            .onAppear {
                breakfastNotification = UserDefaults.standard.bool(forKey: "breakfastNotification")
                lunchNotification = UserDefaults.standard.bool(forKey: "lunchNotification")
                dinnerNotification = UserDefaults.standard.bool(forKey: "dinnerNotification")
            }
            .sheet(isPresented: $isShowingPrivacyPolicyView) {
                PrivacyPolicyView()
            }
        }
    }
}

struct IconView: View {
    let foregroundStyle: Color
    let systemImage: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(foregroundStyle)
                .frame(width: 29, height: 29)
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white)
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    SettingsView()
}
