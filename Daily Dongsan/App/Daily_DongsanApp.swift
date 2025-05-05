//
//  Daily_DongsanApp.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Daily_DongsanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("showOnboardingView") private var showOnboardingView = true
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                if !networkMonitor.isConnected {
                    NoInternetView()
                        .transition(.move(edge: .top))
                }
                
                ContentView()
            }
            .onAppear {
                networkMonitor.startMonitoring()
            }
            .sheet(isPresented: $showOnboardingView) {
                OnboardingView()
                    .interactiveDismissDisabled()
            }
            .animation(.easeInOut(duration: 0.5), value: networkMonitor.isConnected)
        }
    }
}
