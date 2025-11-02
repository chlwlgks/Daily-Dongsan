//
//  FetchSchedules.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/19/25.
//

import Foundation

struct ScheduleResponse: Codable {
    let SchoolSchedule: [SchoolSchedule]
}

struct SchoolSchedule: Codable {
    let row: [cheduleRow]?
}

struct cheduleRow: Codable {
    let EVENT_NM: String // 행사내용
}

class FetchSchedules {
    private let apiKey: String = Bundle.main.infoDictionary!["API Key"] as! String
    
    func fetchSchedules(for date: Date) async -> String? {
//        let date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15))!
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let formattedDate = dateformatter.string(from: date)
        
        guard let url = URL(string: "https://open.neis.go.kr/hub/SchoolSchedule?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&AA_YMD=\(formattedDate)") else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(ScheduleResponse.self, from: data)
            
            if let event = response.SchoolSchedule[1].row?.first?.EVENT_NM {
                return event
            }
        } catch {
            print("학사일정 로드 오류: \(error.localizedDescription)")
        }
        
        return nil
    }
}
