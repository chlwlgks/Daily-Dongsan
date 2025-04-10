//
//  HomeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI
import Network
import FirebaseFirestore

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var isConnected: Bool = true
    
    @State private var meals = [
        Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
    ]
    
    @State private var isShowingSettingsView: Bool = false
    
    @State private var announcement: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if !isConnected {
                    OfflineView()
                } else {
                    VStack {
                        if !announcement.isEmpty {
                            HStack {
                                Label {
                                    Text(announcement)
                                    Spacer()
                                } icon: {
                                    Image(systemName: "megaphone.fill")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.secondary)
                                        .opacity(0.2)
                                )
                            }
                            .padding()
                        }
                        
                        Group {
                            if horizontalSizeClass == .regular {
                                RegularHomeView(meals: meals, currentDate: currentDateString())
                            } else {
                                CompactHomeView(meals: meals, currentDate: currentDateString())
                            }
                        }
                    }
                    .navigationTitle("홈")
                }
            }
            .padding(.horizontal)
            .onAppear {
                monitorNetwork()
                Task {
                    meals = try await fetchMeals(date: Date())
                    announcement = try await fetchAnnouncement()
                }
            }
            .toolbar {
                Button {
                    isShowingSettingsView = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
            .sheet(isPresented: $isShowingSettingsView) {
                MoreView()
            }
        }
    }
    
    private struct RegularHomeView: View {
        let meals: [Meal]
        let currentDate: String
        
        var body: some View {
            VStack {
                Text(currentDate)
                    .font(.system(.title3, weight: .semibold))
                    .padding(.bottom)
                
                HStack(alignment: .top) {
                    ForEach(meals) { meal in
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(meal.mealTime)
                                Spacer()
                                Text(meal.calorie)
                            }
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(.secondary)
                            
                            Text(meal.name)
                        }
                        
                        if meal.id != "3" {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private struct CompactHomeView: View {
        let meals: [Meal]
        let currentDate: String
        
        var body: some View {
            VStack {
                Text(currentDate)
                    .font(.system(.title3, weight: .semibold))
                
                List(meals) { meal in
                    Section {
                        Text(meal.name)
                    } header: {
                        HStack {
                            Text(meal.mealTime)
                            Spacer()
                            Text(meal.calorie)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    private func monitorNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Network Monitor")
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    Task {
                        try await fetchMeals(date: Date())
                    }
                    isConnected = true
                } else {
                    isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func fetchAnnouncement() async throws -> String {
        let db = Firestore.firestore()
        
        let announcement = try await db.collection("announcement").document("content").getDocument().data()?["text"] as? String ?? ""
        
        return announcement
    }
    
    private func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMMM d일 EEEE"
        return dateFormatter.string(from: Date())
    }
}

#Preview {
    HomeView()
}
