//
//  FetchMeals.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import FirebaseFirestore

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
            if mealTypeCode == "2" {
                let mealInfo = rows!.first
                let mealName = mealInfo?.DDISH_NM.replacingOccurrences(of: "<br/>", with: "\n") ?? "급식 정보가 없습니다."
                let calorie = mealInfo?.CAL_INFO ?? ""
                
                fetchedMeals.append(Meal(id: "2", mealTime: "중식", name: mealName, calorie: calorie))
            } else {
                let mealTypeName = mealTimes[mealTypeCode]!
                
                let db = Firestore.firestore()
                
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "yyyy"
                let year = yearFormatter.string(from: date)
                
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MM"
                let month = monthFormatter.string(from: date)
                
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "dd"
                let day = dayFormatter.string(from: date)
                
                do {
                    var mealName = try await db.collection("meals").document(year).collection(month).document(day).getDocument().data()?[mealTypeName] as? String ?? "급식 정보가 없습니다."
                    mealName = mealName.replacingOccurrences(of: "\\n", with: "\n")
                    
                    fetchedMeals.append(Meal(id: mealTypeCode, mealTime: mealTypeName, name: mealName, calorie: ""))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        return fetchedMeals
    } catch {
        print(error.localizedDescription)
        return [
            Meal(id: "1", mealTime: "조식", name: "급식 정보가 없습니다.", calorie: ""),
            Meal(id: "2", mealTime: "중식", name: "급식 정보가 없습니다.", calorie: ""),
            Meal(id: "3", mealTime: "석식", name: "급식 정보가 없습니다.", calorie: "")
        ]
    }
}
