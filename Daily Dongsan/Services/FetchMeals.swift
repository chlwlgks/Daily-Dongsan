//
//  FetchMeals.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/24.
//

import FirebaseFirestore

struct Mealresponse: Codable {
    let mealServiceDietInfo: [MealServiceDietInfo]
}

struct MealServiceDietInfo: Codable {
    let row: [MealRow]?
}

struct MealRow: Codable {
    let MMEAL_SC_CODE: String // 식사코드
    let MMEAL_SC_NM: String // 식사명
    let DDISH_NM: String // 요리명
    let CAL_INFO: String // 칼로리정보
}

class FetchMeals {
    private let apiKey: String = Bundle.main.infoDictionary!["API Key"] as! String
    
    func fetchMeals(for date: Date) async -> [Meal] {
//        let date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15))!
        
        var meals: [Meal] = [
            Meal(mealKind: .breakfast),
            Meal(mealKind: .lunch),
            Meal(mealKind: .dinner)
        ]
        
        async let bdResult = fetchBreakfastAndDinner(for: date)
        async let lunchResult = fetchLunch(for: date)
        
        let (bd, lunch) = await (bdResult, lunchResult)
        
        if let breakfast = bd?["1"], let idx = meals.firstIndex(where: { $0.mealKind.rawValue == "1" }) {
            meals[idx].menus = breakfast
        }
        if let dinner = bd?["3"], let idx = meals.firstIndex(where: { $0.mealKind.rawValue == "3" }) {
            meals[idx].menus = dinner
        }
        if let lunch, let idx = meals.firstIndex(where: { $0.mealKind.rawValue == "2" }) {
            meals[idx].menus = lunch.menus
            meals[idx].calorieInfo = lunch.calorie
        }
        
        return meals
    }
    
    private func fetchBreakfastAndDinner(for date: Date) async -> [String: [Menu]]? {
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
            let data = try await db
                .collection("meals").document(year)
                .collection(month).document(day)
                .getDocument().data()
            guard let data else { return nil }
            
            var result: [String: [Menu]] = [:]
            for mealCode in ["1", "3"] {
                guard let mealType = MealKind(rawValue: mealCode)?.displayName else { continue }
                
                if var mealName = data[mealType] as? String {
                    mealName = mealName.replacingOccurrences(of: ",", with: ".")
                    mealName = mealName.replacingOccurrences(of: "\\n", with: "<br/>")
                    
                    result[mealCode] = parseMeals(from: mealName)
                }
            }
            
            return result
        } catch {
            print("Firestore 로드 오류: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func fetchLunch(for date: Date) async -> (menus: [Menu], calorie: String?)? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let formattedDate = dateformatter.string(from: date)
        
        guard let url = URL(string: "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&MLSV_YMD=\(formattedDate)") else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(Mealresponse.self, from: data)
            
            if let rows = response.mealServiceDietInfo[1].row {
                if let row = rows.first(where: { $0.MMEAL_SC_CODE == "2" }) {
                    let menus = parseMeals(from: row.DDISH_NM)
                    return (menus, row.CAL_INFO)
                }
            }
        } catch {
            print("중식 로드 오류: \(error.localizedDescription)")
        }
        
        return nil
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
