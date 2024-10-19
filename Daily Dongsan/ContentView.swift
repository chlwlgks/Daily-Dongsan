//
//  ContentView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var resetBarcode: Bool = UserDefaults.standard.bool(forKey: "resetBarcode")
    
    @State private var isShowingBarcodeResetView: Bool = false
    
    var body: some View {
        TabView() {
            Tab("홈", systemImage: "house") {
                HomeView()
            }
            Tab("식단", systemImage: "calendar") {
                MealsView()
            }
            Tab("학생증", systemImage: "person.text.rectangle") {
                BarcodeView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .onAppear {
            if resetBarcode {
                isShowingBarcodeResetView = true
            }
        }
        .sheet(isPresented: $isShowingBarcodeResetView, onDismiss: {
            UserDefaults.standard.set(false, forKey: "resetBarcode")
        }, content: {
            BarcodeResetView(resetBarcode: $resetBarcode)
        })
    }
}

struct BarcodeResetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var resetBarcode: Bool
    
    @State private var passcode: String = ""
    
    private class HapticManager {
        @MainActor static let instance = HapticManager()
        
        @MainActor func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
            UINotificationFeedbackGenerator().notificationOccurred(notificationType)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                SecureField("암호 입력", text: $passcode)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray)
                    }
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                Button {
                    if passcode == "4013" {
                        UserDefaults.standard.removeObject(forKey: "savedCode")
                        HapticManager.instance.notification(notificationType: .success)
                        dismiss()
                    }
                } label: {
                    Text("완료")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .navigationBarTitle("학생증 재설정")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
