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
    @Published var isTimetableLoading: Bool = true
    @Published var isTimetableEmpty: Bool = false
    
    var entries: [TimetableEntry] = []
    
    @Published var selectedGrade: Int {
        didSet {
            UserDefaults.standard.set(selectedGrade, forKey: "selectedGrade")
            Task {
                await fetchTimetable(containing: Date())
            }
        }
    }
    @Published var selectedClass: Int {
        didSet {
            UserDefaults.standard.set(selectedClass, forKey: "selectedClass")
            Task {
                await fetchTimetable(containing: Date())
            }
        }
    }
    
    init() {
        selectedGrade = UserDefaults.standard.object(forKey: "selectedGrade") as? Int ?? 1
        selectedClass = UserDefaults.standard.object(forKey: "selectedClass") as? Int ?? 1
        
        Task {
            await fetchTimetable(containing: Date())
        }
    }
    
    private func mondayOfWeek(containing date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let weekday = calendar.component(.weekday, from: date)
        let daysFromMonday = (weekday == 1) ? 1 : (2 - weekday)
        return calendar.date(byAdding: .day, value: daysFromMonday, to: calendar.startOfDay(for: date))!
    }
    
    private func weekday(from yyyyMMdd: String) -> Weekday? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        dateformatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
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
    
    private let apiKey: String = Bundle.main.infoDictionary!["API Key"] as! String
    func fetchTimetable(containing date: Date) async {
        await updateTimetableState(loading: true, isEmpty: false)
        
        let monday = mondayOfWeek(containing: date)
        
        let calendar = Calendar(identifier: .gregorian)
        let friday = calendar.date(byAdding: .day, value: 4, to: monday)!
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        
        let from = dateformatter.string(from: monday)
        let to = dateformatter.string(from: friday)
        
        let url = URL(string: "https://open.neis.go.kr/hub/hisTimetable?KEY=\(apiKey)&Type=json&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530184&GRADE=\(selectedGrade)&CLASS_NM=\(selectedClass)&TI_FROM_YMD=\(from)&TI_TO_YMD=\(to)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(HisTimetableResponse.self, from: data)
            
            let rows = response.hisTimetable[1].row!
            
            var newEntries: [TimetableEntry] = []
            for row in rows {
                let day = weekday(from: row.ALL_TI_YMD)
                let period = Int(row.PERIO)!
                let subject = row.ITRT_CNTNT
                
                newEntries.append(TimetableEntry(day: day!, period: period, subject: subject))
            }
            
            await updateEntries(newEntries)
            await updateTimetableState(loading: false, isEmpty: false)
        } catch {
            await updateTimetableState(loading: false, isEmpty: true)
            print("시간표 로드 오류: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func updateTimetableState(loading: Bool, isEmpty: Bool) {
        withAnimation {
            isTimetableLoading = loading
            isTimetableEmpty = isEmpty
        }
    }
    
    @MainActor
    private func updateEntries(_ entries: [TimetableEntry]) {
        self.entries = entries
    }
}
