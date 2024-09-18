//
//  MealService.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/16/24.
//

import Foundation

struct Meal: Identifiable {
    let id: String
    let mealTime: String
    let name: String
    let calorie: String
}

class MealService: ObservableObject {
    private let mealTimes: [String : String] = ["1" : "조식", "2" : "중식", "3" : "석식"]
    @Published var meals = [
        Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
        Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
    ]
    
    @Published var errorMessage: String?
    
    private let apiKey = Bundle.main.infoDictionary?["API Key"]
    
    func fetchMeals(date: Date){
        
        guard let apiKey else {
            error(message: "API Key 없음")
            return
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let currentDate = dateformatter.string(from: date)
        
        let url = "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&MLSV_YMD=\(currentDate)"
        guard let url = URL(string: url) else {
            error(message: "URL 생성 실패")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                self.error(message: error.localizedDescription)
                return
            }
            
            guard let data else {
                self.error(message: "데이터 없음")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Mealresponse.self, from: data)
                
                guard let rows = response.mealServiceDietInfo[1].row else {
                    self.error(message: "데이터 없음")
                    return
                }
                
                var fetchedMeals: [Meal] = []
                
                for mealTypeCode in ["1", "2", "3"] {
                    guard let mealTypeName = self.mealTimes[mealTypeCode] else {
                        self.error(message: "데이터 없음")
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
                    self.meals = fetchedMeals
                    self.errorMessage = nil
                }
            } catch {
                var tempMeals: [Meal] = []
                
                tempMeals.append(Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""))
                tempMeals.append(Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""))
                tempMeals.append(Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: ""))
                
                DispatchQueue.main.async {
                    self.meals = tempMeals
                    self.errorMessage = nil
                }
            }
        }
        .resume()
    }
    
    private func error(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
}
