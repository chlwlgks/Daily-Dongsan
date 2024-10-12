//
//  SettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/13/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label {
                            Text("알림")
                        } icon: {
                            IconView(foregroundStyle: Color.red, systemImage: "bell.badge.fill")
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        Text("없어요.")
                    } label: {
                        Label {
                            Text("개인정보 처리방침")
                        } icon: {
                            IconView(foregroundStyle: Color.gray, systemImage: "text.document.fill")
                        }
                    }
                }
                
                Section {
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
        }
    }
}

struct NotificationSettingsView: View {
    @State private var notifications: Bool = false
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $notifications) {
                        Text("조식 알림")
                    }
                    DatePicker("시간", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    Toggle(isOn: $notifications) {
                        Text("중식 알림")
                    }
                    DatePicker("시간", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    Toggle(isOn: $notifications) {
                        Text("조식 알림")
                    }
                    DatePicker("시간", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("알림")
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
                .frame(width: 30, height: 30)
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white)
                .frame(width: 20, height: 20)
        }
    }
}

struct AppInfoView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("데일리 동산")
                    .font(.largeTitle)
            }
            .navigationTitle("앱 정보")
        }
    }
}

#Preview {
    SettingsView()
}
