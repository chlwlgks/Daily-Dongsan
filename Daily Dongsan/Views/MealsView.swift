//
//  MealsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/15/24.
//

import SwiftUI
import Network

struct MealsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var isConnected: Bool = true
    
    @State var meals: [Meal]? = [
        Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
    ]
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            Group {
                if !isConnected {
                    OfflineView()
                } else {
                    Group {
                        if horizontalSizeClass == .regular {
                            RegularMealView(meals: meals, selectedDate: $selectedDate)
                        } else {
                            CompactMealView(meals: meals, selectedDate: $selectedDate)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    }
                    .navigationTitle("식단")
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            .onAppear {
                monitorNetwork()
                Task {
                    meals = try await fetchMeals(date: selectedDate)
                }
            }
            .onChange(of: selectedDate) {
                Task {
                    meals = try await fetchMeals(date: selectedDate)
                }
            }
        }
    }
    
    private struct RegularMealView: View {
        let meals: [Meal]?
        @Binding var selectedDate: Date
        
        var body: some View {
            HStack(alignment: .top) {
                VStack(spacing: 16) {
                    DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    Button("오늘") {
                        selectedDate = Date()
                    }
                }
                
                VStack {
                    var formattedDate: String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ko_KR")
                        dateFormatter.dateFormat = "MMMM d일 EEEE"
                        return dateFormatter.string(from: selectedDate)
                    }
                    
                    Text(formattedDate)
                        .font(.title3)
                        .bold()
                    List(meals!) { meal in
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
                }
            }
        }
    }
    
    private struct CompactMealView: View {
        var meals: [Meal]?
        @Binding var selectedDate: Date
        
        var body: some View {
            VStack {
                DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                var formattedDate: String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ko_KR")
                    dateFormatter.dateFormat = "MMMM d일 EEEE"
                    return dateFormatter.string(from: selectedDate)
                }
                
                VStack {
                    List(meals!) { meal in
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
                }
            }
        }
    }
    
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Network Monitor")
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    Task {
                        try await fetchMeals(date: selectedDate)
                    }
                    isConnected = true
                } else {
                    isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}

#Preview {
    MealsView()
}
