//
//  TimetableViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 8/20/25.
//

import Foundation
import SwiftUI

enum Weekday: Int, CaseIterable {
    case monday = 0, tuesday, wednesday, thursday, friday
    var title: String {
        ["월","화","수","목","금"][rawValue]
    }
}

class TimetableViewModel: ObservableObject {
    @Published var entries: [TimetableEntry] = []
    @Published var isTimetableLoading: Bool = true
    
    init() {
        Task {
            await fetchWeekTimetable(containing: Date())
        }
    }

    func subject(for day: Weekday, period: String) -> String {
        return entries.first { $0.day == day && $0.period == period }?.subject ?? ""
    }
    
    func fetchWeekTimetable(containing date: Date) async {
        let calendar = Calendar(identifier: .gregorian)
        let monday = mondayOfWeek(containing: date)
        
        for offset in 0..<5 {
            if let day = calendar.date(byAdding: .day, value: offset, to: monday) {
                await fetchTimetable(for: day)
            }
        }
        
        Task { @MainActor in
            withAnimation {
                isTimetableLoading = false
            }
        }
    }
    
    private func mondayOfWeek(containing date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let weekday = calendar.component(.weekday, from: date)
        let daysFromMonday = (weekday == 1) ? 1 : (2 - weekday)
        return calendar.date(byAdding: .day, value: daysFromMonday, to: calendar.startOfDay(for: date))!
    }
    
    private let apiKey: String = Bundle.main.infoDictionary!["API Key"] as! String
    
    func fetchTimetable(for date: Date) async {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let formattedDate = dateformatter.string(from: date)
        
//        let url = URL(string: "https://open.neis.go.kr/hub/hisTimetable?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&ALL_TI_YMD=\(formattedDate)&GRADE=3&CLASS_NM=12")!
        let url = URL(string: "https://open.neis.go.kr/hub/hisTimetable?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&ALL_TI_YMD=\(formattedDate)&GRADE=3&CLASS_NM=12")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(HisTimetableResponse.self, from: data)
            
            applyDecodedResponse(response)
        } catch {
            print("시간표 로드 오류: \(error.localizedDescription)")
        }
    }
    
    private func applyDecodedResponse(_ response: HisTimetableResponse) {
        let rows = response.hisTimetable[1].row!
        for row in rows {
            let day = weekday(from: row.ALL_TI_YMD)
            let period = row.PERIO
            let subject = row.ITRT_CNTNT
            
            Task { @MainActor in
                entries.removeAll { $0.day == day && $0.period == period }
                entries.append(TimetableEntry(day: day!, period: period, subject: subject))
            }
        }
    }
    
    private func weekday(from yyyyMMdd: String) -> Weekday? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        dateformatter.timeZone = TimeZone(abbreviation: "KST")
        
        let date = dateformatter.date(from: yyyyMMdd)
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: date!)
        
        switch weekday {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        default: return nil
        }
    }
}
