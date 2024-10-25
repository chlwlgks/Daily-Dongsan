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
    
    @State private var isShowingAllergyView: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if !isConnected {
                    OfflineView()
                } else {
                    Group {
                        if horizontalSizeClass == .regular {
                            RegularMealView(meals: meals, selectedDate: $selectedDate,isShowingAllergyView: $isShowingAllergyView)
                        } else {
                            CompactMealView(meals: meals, selectedDate: $selectedDate, isShowingAllergyView: $isShowingAllergyView)
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
            .sheet(isPresented: $isShowingAllergyView) {
                AllergyView()
            }
        }
    }
    
    private struct RegularMealView: View {
        let meals: [Meal]?
        @Binding var selectedDate: Date
        @Binding var isShowingAllergyView: Bool
        
        var body: some View {
            HStack(alignment: .top) {
                VStack(spacing: 16) {
                    DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    HStack {
                        Spacer()
                        Button {
                            isShowingAllergyView = true
                        } label: {
                            Text("알레르기")
                        }
                        Spacer()
                        Button {
                            selectedDate = Date()
                        } label: {
                            Text("오늘")
                        }
                        Spacer()
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
        @Binding var isShowingAllergyView: Bool
        
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
            .toolbar {
                Button {
                    isShowingAllergyView = true
                } label: {
                    Text("알레르기")
                }
                
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

private struct AllergyView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let allergyData = [
        Allergy(id: "1", name: "알류"), Allergy(id: "2", name: "우유"), Allergy(id: "3", name: "메밀"),
        Allergy(id: "4", name: "땅콩"), Allergy(id: "5", name: "대두"), Allergy(id: "6", name: "밀"),
        Allergy(id: "7", name: "고등어"), Allergy(id: "8", name: "게"), Allergy(id: "9", name: "새우"),
        Allergy(id: "10", name: "돼지고기"), Allergy(id: "11", name: "복숭아"), Allergy(id: "12", name: "토마토"),
        Allergy(id: "13", name: "아황산염"), Allergy(id: "14", name: "호두"), Allergy(id: "15", name: "닭고기"),
        Allergy(id: "16", name: "쇠고기"), Allergy(id: "17", name: "오징어"), Allergy(id: "18", name: "조개류 (굴·전복·홍합)"),
        Allergy(id: "19", name: "잣"), Allergy(id: "20", name: "박준우")
    ]
    
    var body: some View {
        NavigationStack {
            List(allergyData) { allergy in
                if allergy.id == "20" {
                    NavigationLink {
                        ParkJunWooView()
                    } label: {
                        Text("\(allergy.id). \(allergy.name)")
                    }
                } else {
                    Text("\(allergy.id). \(allergy.name)")
                }
            }
            .navigationTitle("알레르기 유발 식품")
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

#Preview {
    MealsView()
}
