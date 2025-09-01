//
//  Timetable.swift
//  Daily Dongsan
//
//  Created by 최지한 on 8/20/25.
//

import Foundation

struct TimetableEntry: Identifiable {
    let id = UUID()
    let day: Weekday
    let period: String
    let subject: String
}

extension TimetableEntry {
    static let sampleTimetable: [TimetableEntry] = [
        TimetableEntry(day: .monday, period: "1", subject: "자율"),
        TimetableEntry(day: .monday, period: "2", subject: "영어 독해와 작문"),
        TimetableEntry(day: .monday, period: "3", subject: "D"),
        TimetableEntry(day: .monday, period: "4", subject: "D"),
        TimetableEntry(day: .monday, period: "5", subject: "C"),
        TimetableEntry(day: .monday, period: "6", subject: "A"),
        TimetableEntry(day: .monday, period: "7", subject: "정보과학"),
        TimetableEntry(day: .tuesday, period: "1", subject: "심화 수학Ⅱ"),
        TimetableEntry(day: .tuesday, period: "2", subject: "C"),
        TimetableEntry(day: .tuesday, period: "3", subject: "영어 독해와 작문"),
        TimetableEntry(day: .tuesday, period: "4", subject: "B"),
        TimetableEntry(day: .tuesday, period: "5", subject: "A"),
        TimetableEntry(day: .tuesday, period: "6", subject: "미술 감상과 비평"),
        TimetableEntry(day: .tuesday, period: "7", subject: "독서"),
        TimetableEntry(day: .wednesday, period: "1", subject: "독서"),
        TimetableEntry(day: .wednesday, period: "2", subject: "D"),
        TimetableEntry(day: .wednesday, period: "3", subject: "C"),
        TimetableEntry(day: .wednesday, period: "4", subject: "스포츠 생활"),
        TimetableEntry(day: .wednesday, period: "5", subject: "영어 독해와 작문"),
        TimetableEntry(day: .wednesday, period: "6", subject: "심화 수학Ⅱ"),
        TimetableEntry(day: .thursday, period: "1", subject: "B"),
        TimetableEntry(day: .thursday, period: "2", subject: "가정과학"),
        TimetableEntry(day: .thursday, period: "3", subject: "독서"),
        TimetableEntry(day: .thursday, period: "4", subject: "종교와 삶Ⅱ"),
        TimetableEntry(day: .thursday, period: "5", subject: "심화 수학Ⅱ"),
        TimetableEntry(day: .thursday, period: "6", subject: "영어 독해와 작문"),
        TimetableEntry(day: .thursday, period: "7", subject: "공강"),
        TimetableEntry(day: .friday, period: "1", subject: "예배"),
        TimetableEntry(day: .friday, period: "2", subject: "A"),
        TimetableEntry(day: .friday, period: "3", subject: "진로"),
        TimetableEntry(day: .friday, period: "4", subject: "동아리"),
        TimetableEntry(day: .friday, period: "5", subject: "정보과학"),
        TimetableEntry(day: .friday, period: "6", subject: "심화 수학Ⅱ"),
        TimetableEntry(day: .friday, period: "7", subject: "B"),
    ]
}

struct HisTimetableResponse: Decodable {
    let hisTimetable: [HisTimetable]
}

struct HisTimetable: Codable {
    let row: [TimetableRow]?
}

struct TimetableRow: Codable {
    let ALL_TI_YMD: String
    let PERIO: String
    let ITRT_CNTNT: String
}
