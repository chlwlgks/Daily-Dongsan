//
//  FetchMeals.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import FirebaseFirestore

class FetchMeals {
    private let apiKey: String = Bundle.main.infoDictionary!["API Key"] as! String
    
    private let mealTimes: [String : String] = ["1" : "조식", "2" : "중식", "3" : "석식"]
    
    func fetchMeals(for date: Date) async -> [Meal] {
//        let date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15))!
        
        var meals: [Meal] = [
            Meal(mealCode: "1", mealType: "조식"),
            Meal(mealCode: "2", mealType: "중식"),
            Meal(mealCode: "3", mealType: "석식")
        ]
        
        // MARK: - 조식, 석식
        for mealCode in ["1", "3"] {
            let mealType = mealTimes[mealCode]!
            
            let db = Firestore.firestore()
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            let year = yearFormatter.string(from: date)
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM"
            let month = monthFormatter.string(from: date)
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d"
            let day = dayFormatter.string(from: date)
            
            do {
                var mealName = try await db.collection("meals").document(year).collection(month).document(day).getDocument().data()?[mealType] as? String? ?? nil
                if mealName != nil {
                    mealName = mealName!.replacingOccurrences(of: ",", with: ".")
                    mealName = mealName!.replacingOccurrences(of: "\\n", with: "<br/>")
                    
                    if let index = meals.firstIndex(where: { $0.mealCode == mealCode }) {
                        meals[index].menus = parseMeals(from: mealName!)
                    }
                }
            } catch {
                print("\(mealType) 로드 오류: \(error.localizedDescription)")
            }
        }
        
// MARK: - 중식
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let formattedDate = dateformatter.string(from: date)
        
        let url = URL(string: "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&MLSV_YMD=\(formattedDate)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(Mealresponse.self, from: data)
            
            let rows = response.mealServiceDietInfo[1].row!
            for row in rows {
                if let index = meals.firstIndex(where: { $0.mealCode == row.MMEAL_SC_CODE }) {
                    meals[index].menus = parseMeals(from: row.DDISH_NM)
                    meals[index].calorieInfo = row.CAL_INFO
                }
            }
        } catch {
            print("중식 로드 오류: \(error.localizedDescription)")
        }
        
        return meals
    }
    
    private func parseMeals(from meal: String) -> [Menu] {
        var parsedMenus: [Menu] = []
        
        let lines = meal.split(separator: "<br/>").compactMap { line in
            String(line).trimmingCharacters(in: .whitespaces)
        }
        for line in lines {
            var name = line
            var allergies: Set<String>?
            
            if let closeParenIndex = line.lastIndex(of: ")") {
                var balance = 0
                var matchingopenParenIndex: String.Index? = nil
                
                for i in line.indices[..<closeParenIndex].reversed() {
                    if line[i] == ")" {
                        balance += 1
                    } else if line[i] == "(" {
                        if balance == 0 {
                            matchingopenParenIndex = i
                            break
                        } else {
                            balance -= 1
                        }
                    }
                }
                
                if let openParenIndex = matchingopenParenIndex {
                    let inside = String(line[line.index(after: openParenIndex)...line.index(before: closeParenIndex)])
                    if isAllergyString(in: inside) {
                        let codes = inside
                            .components(separatedBy: CharacterSet(charactersIn: ".*"))
                            .compactMap { part in
                            return part
                                    .replacingOccurrences(of: "(", with: "")
                                    .replacingOccurrences(of: ")", with: "")
                        }
                        allergies = Set(codes)
                        name = String(line[...line.index(before: openParenIndex)]).trimmingCharacters(in: .whitespaces)
                    }
                }
            }
            
            parsedMenus.append(Menu(name: name, allergies: allergies))
        }
        
        return parsedMenus
    }
    
    private func isAllergyString(in string: String) -> Bool {
        for char in string {
            if !(char.isNumber || char == "." || char == "(" || char == ")" || char == "*") {
                return false
            }
        }
        return true
    }
}
