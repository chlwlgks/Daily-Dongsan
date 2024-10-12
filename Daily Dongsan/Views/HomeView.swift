//
//  HomeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var meals = [
        Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
    ]
    private let mealTimes: [String : String] = ["1" : "조식", "2" : "중식", "3" : "석식"]
    
    @State private var currentDate: String = ""
    
    @State private var errorMessage: String?
    
    private let apiKey = Bundle.main.infoDictionary?["API Key"]
    
    @State private var isShowingSettings: Bool = false
    
    @State var dkdrlah = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(dkdrlah)")
                if horizontalSizeClass == .regular {
                    RegularHomeView(meals: meals, currentDate: currentDate, errorMessage: errorMessage)
                } else {
                    CompactHomeView(meals: meals, currentDate: currentDate, errorMessage: errorMessage)
                }
            }
            .padding(.horizontal)
            .onAppear {
                currentDate = currentDateString()
                fetchMeals(date: Date())
            }
            .navigationTitle("홈")
            .toolbar {
                Button {
                    isShowingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }
    
    private struct RegularHomeView: View {
        let meals: [Meal]
        let currentDate: String
        let errorMessage: String?
        
        var body: some View {
            VStack {
                if let errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    Text(currentDate)
                        .font(.title3)
                        .bold()
                        .padding(.bottom)
                    
                    HStack(alignment: .top) {
                        ForEach(meals) { meal in
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text(meal.mealTime)
                                    Spacer()
                                    Text(meal.calorie)
                                }
                                .foregroundStyle(.gray)
                                
                                Text(meal.name)
                            }
                            
                            if meal.id != "3" {
                                Divider()
                                    .padding(.horizontal)
                            }
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
        let errorMessage: String?
        
        var body: some View {
            VStack {
                if let errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    Text(currentDate)
                        .font(.title3)
                        .bold()
                    
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
    }
    
    private func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMMM d일 EEEE"
        return dateFormatter.string(from: Date())
    }
    
    private func startMidnightTimer() {
        let calendar = Calendar.current
        let now = Date()
        let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0), matchingPolicy: .nextTime) ?? now
        
        let timeInterval = nextMidnight.timeIntervalSince(now)
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            currentDate = currentDateString()
            fetchMeals(date: Date())
            startMidnightTimer()
            dkdrlah += 1
        }
    }
    
    private func fetchMeals(date: Date) {
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
    HomeView()
}
