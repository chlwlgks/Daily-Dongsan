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
    let period: Int
    let subject: String
}

extension TimetableEntry {
    static let sampleTimetable: [TimetableEntry] = [
        TimetableEntry(day: .monday, period: 1, subject: "1교시"),
        TimetableEntry(day: .monday, period: 2, subject: "2교시"),
        TimetableEntry(day: .monday, period: 3, subject: "3교시"),
        TimetableEntry(day: .monday, period: 4, subject: "4교시"),
        TimetableEntry(day: .monday, period: 5, subject: "5교시"),
        TimetableEntry(day: .monday, period: 6, subject: "6교시"),
        TimetableEntry(day: .monday, period: 7, subject: "7교시"),
        TimetableEntry(day: .monday, period: 8, subject: "8교시"),
        TimetableEntry(day: .tuesday, period: 1, subject: "1교시"),
        TimetableEntry(day: .tuesday, period: 2, subject: "2교시"),
        TimetableEntry(day: .tuesday, period: 3, subject: "3교시"),
        TimetableEntry(day: .tuesday, period: 4, subject: "4교시"),
        TimetableEntry(day: .tuesday, period: 5, subject: "5교시"),
        TimetableEntry(day: .tuesday, period: 6, subject: "6교시"),
        TimetableEntry(day: .tuesday, period: 7, subject: "7교시"),
        TimetableEntry(day: .tuesday, period: 8, subject: "8교시"),
        TimetableEntry(day: .wednesday, period: 1, subject: "1교시"),
        TimetableEntry(day: .wednesday, period: 2, subject: "2교시"),
        TimetableEntry(day: .wednesday, period: 3, subject: "3교시"),
        TimetableEntry(day: .wednesday, period: 4, subject: "4교시"),
        TimetableEntry(day: .wednesday, period: 5, subject: "5교시"),
        TimetableEntry(day: .wednesday, period: 6, subject: "6교시"),
        TimetableEntry(day: .wednesday, period: 7, subject: "7교시"),
        TimetableEntry(day: .wednesday, period: 8, subject: "8교시"),
        TimetableEntry(day: .thursday, period: 1, subject: "1교시"),
        TimetableEntry(day: .thursday, period: 2, subject: "2교시"),
        TimetableEntry(day: .thursday, period: 3, subject: "3교시"),
        TimetableEntry(day: .thursday, period: 4, subject: "4교시"),
        TimetableEntry(day: .thursday, period: 5, subject: "5교시"),
        TimetableEntry(day: .thursday, period: 6, subject: "6교시"),
        TimetableEntry(day: .thursday, period: 7, subject: "7교시"),
        TimetableEntry(day: .thursday, period: 8, subject: "8교시"),
        TimetableEntry(day: .friday, period: 1, subject: "1교시"),
        TimetableEntry(day: .friday, period: 2, subject: "2교시"),
        TimetableEntry(day: .friday, period: 3, subject: "3교시"),
        TimetableEntry(day: .friday, period: 4, subject: "4교시"),
        TimetableEntry(day: .friday, period: 5, subject: "5교시"),
        TimetableEntry(day: .friday, period: 6, subject: "6교시"),
        TimetableEntry(day: .friday, period: 7, subject: "7교시"),
        TimetableEntry(day: .friday, period: 8, subject: "8교시"),
    ]
}

struct HisTimetableResponse: Decodable {
    let hisTimetable: [HisTimetable]
}

struct HisTimetable: Codable {
    let row: [TimetableRow]?
}

struct TimetableRow: Codable {
    let ALL_TI_YMD: String // 시간표일자
    let PERIO: String // 교시
    let ITRT_CNTNT: String // 수업내용
}
