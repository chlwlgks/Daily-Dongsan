//
//  FetchMeals.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import Foundation

private let apiKey: String = Bundle.main.infoDictionary!["API Key"] as! String

private let mealTimes: [String : String] = ["1" : "조식", "2" : "중식", "3" : "석식"]

func fetchMeals(date: Date) async throws -> [Meal] {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyyMMdd"
    let currentDate = dateformatter.string(from: date)
    
    let url = URL(string: "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&MLSV_YMD=\(currentDate)")!
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    do {
        let mealResponse = try decoder.decode(Mealresponse.self, from: data)
        
        let rows = mealResponse.mealServiceDietInfo[1].row
        
        var fetchedMeals: [Meal] = []
        
        for mealTypeCode in ["1", "2", "3"] {
            let mealTypeName = mealTimes[mealTypeCode]!
            
            if let mealInfo = rows!.first(where: { mealInfo in
                mealInfo.MMEAL_SC_CODE == mealTypeCode
            }) {
                let mealName = mealInfo.DDISH_NM.replacingOccurrences(of: "<br/>", with: "\n")
                let calorie = mealInfo.CAL_INFO
                
                fetchedMeals.append(Meal(id: mealTypeCode, mealTime: mealTypeName, name: mealName, calorie: calorie))
            } else {
                fetchedMeals.append(Meal(id: mealTypeCode, mealTime: mealTypeName, name: "급식 정보가 없습니다.", calorie: ""))
            }
        }
        
        return fetchedMeals
    } catch {
        return [
            Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
            Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
            Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
        ]
    }
}
