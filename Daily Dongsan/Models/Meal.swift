//
//  Meal.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import Foundation

struct Meal: Identifiable {
    let id: String
    let mealTime: String
    let name: String
    let calorie: String
}

struct Mealresponse: Codable {
    var mealServiceDietInfo: [MealServiceDietInfo]
}

struct MealServiceDietInfo: Codable {
    var row: [MealRow]?
}

struct MealRow: Codable {
    var MMEAL_SC_CODE: String //식사코드
    var MMEAL_SC_NM: String // 식사명
    var MLSV_YMD: String //급식일자
    var DDISH_NM: String //요리명
    var CAL_INFO: String //칼로리정보
}
