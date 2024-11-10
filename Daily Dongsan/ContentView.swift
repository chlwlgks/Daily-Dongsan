//
//  ContentView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State var resetBarcode: Bool = UserDefaults.standard.bool(forKey: "resetBarcode")
    
    @State private var isShowingBarcodeResetView: Bool = false
    
    var body: some View {
        if #available(iOS 18, *) {
            TabView() {
//                                Tab("홈", systemImage: "house") {
//                                    HomeView()
//                                }
//                                Tab("식단", systemImage: "calendar") {
//                                    MealsView()
//                                }
//                                Tab("학생증", systemImage: "person.text.rectangle") {
//                                    BarcodeView()
//                                }
                
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                MealsView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("식단")
                    }
                BarcodeView()
                    .tabItem {
                        Image(systemName: "person.text.rectangle")
                        Text("학생증")
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
        } else {
            Group {
                if horizontalSizeClass == .regular {
                    NavigationSplitView {
                        List {
                            NavigationLink {
                                HomeView()
                            } label: {
                                Label("홈", systemImage: "house")
                            }
                            NavigationLink {
                                MealsView()
                            } label: {
                                Label("식단", systemImage: "calendar")
                            }
                            NavigationLink {
                                BarcodeView()
                            } label: {
                                Label("학생증", systemImage: "person.text.rectangle")
                            }
                        }
                    } detail: {
                        HomeView()
                    }
                } else {
                    TabView() {
                        HomeView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("홈")
                            }
                        MealsView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("식단")
                            }
                        BarcodeView()
                            .tabItem {
                                Image(systemName: "person.text.rectangle")
                                Text("학생증")
                            }
                    }
                }
            }
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
}

struct BarcodeResetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var resetBarcode: Bool
    
    @State private var passcode: String = ""
    
    private class HapticManager {
        static let instance = HapticManager()
        
        func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
            UINotificationFeedbackGenerator().notificationOccurred(notificationType)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                SecureField("암호 입력", text: $passcode)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary)
                    }
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
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
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
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
            .frame(maxWidth: 450)
        }
    }
}

#Preview {
    ContentView()
}
