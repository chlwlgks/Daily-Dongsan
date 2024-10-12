//
//  MealsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/15/24.
//

import SwiftUI

struct MealsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var meals = [
        Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
    ]
    private let mealTimes: [String : String] = ["1" : "조식", "2" : "중식", "3" : "석식"]
    
    @State var errorMessage: String?
    
    private let apiKey = Bundle.main.infoDictionary?["API Key"]
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    RegularMealView(meals: meals, selectedDate: $selectedDate, errorMessage: errorMessage)
                } else {
                    CompactMealView(meals: meals, selectedDate: $selectedDate, errorMessage: errorMessage)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            .navigationTitle("식단")
            .onAppear {
                fetchMeals(date: selectedDate)
            }
            .onChange(of: selectedDate) {
                fetchMeals(date: selectedDate)
            }
        }
    }
    
    private struct RegularMealView: View {
        let meals: [Meal]?
        @Binding var selectedDate: Date
        let errorMessage: String?
        
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
                    
                    if let errorMessage {
                        HStack{
                            Spacer()
                            VStack {
                                Spacer()
                                Text(errorMessage)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            Spacer()
                        }
                    } else if let meals {
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
                    }
                }
            }
        }
    }
    
    private struct CompactMealView: View {
        let meals: [Meal]?
        @Binding var selectedDate: Date
        let errorMessage: String?
        
        var body: some View {
            VStack {
                DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                if let errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else if let meals {
                    var formattedDate: String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ko_KR")
                        dateFormatter.dateFormat = "MMMM d일 EEEE"
                        return dateFormatter.string(from: selectedDate)
                    }
                    
                    VStack {
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
                    }
                }
            }
        }
    }
    
    func fetchMeals(date: Date) {
        guard let apiKey else {
            error("API Key가 존재하지 않습니다.")
            return
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let currentDate = dateformatter.string(from: date)
        
        let url = "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&MLSV_YMD=\(currentDate)"
        guard let url = URL(string: url) else {
            error("URL 생성에 실패했습니다.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                self.error(error.localizedDescription)
                return
            }
            
            guard let data else {
                self.error("데이터가 없습니다.")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Mealresponse.self, from: data)
                
                guard let rows = response.mealServiceDietInfo[1].row else {
                    self.error("데이터가 없습니다.")
                    return
                }
                
                var fetchedMeals: [Meal] = []
                
                for mealTypeCode in ["1", "2", "3"] {
                    guard let mealTypeName = self.mealTimes[mealTypeCode] else {
                        self.error("데이터가 없습니다.")
                        return
                    }
                    
                    if let mealInfo = rows.first(where: { mealInfo in
                        mealInfo.MMEAL_SC_CODE == mealTypeCode
                    }) {
                        let mealName = mealInfo.DDISH_NM.replacingOccurrences(of: "<br/>", with: "\n")
                        let calorie = mealInfo.CAL_INFO
                        
                        fetchedMeals.append(Meal(id: mealTypeCode, mealTime: mealTypeName, name: mealName, calorie: calorie))
                    } else {
                        fetchedMeals.append(Meal(id: mealTypeCode, mealTime: mealTypeName, name: "급식 정보가 없습니다.", calorie: ""))
                    }
                }
                
                DispatchQueue.main.async {
                    meals = fetchedMeals
                    errorMessage = nil
                }
            } catch {
                var tempMeals: [Meal] = []
                
                tempMeals.append(Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""))
                tempMeals.append(Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""))
                tempMeals.append(Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: ""))
                
                DispatchQueue.main.async {
                    meals = tempMeals
                    errorMessage = nil
                }
            }
        }
        .resume()
    }
    
    private func error(_ message: String) {
        DispatchQueue.main.async {
            errorMessage = message
        }
    }
}

#Preview {
    MealsView()
}
