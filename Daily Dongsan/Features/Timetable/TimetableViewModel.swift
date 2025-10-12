//
//  TimetableViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 8/20/25.
//

import Foundation
import SwiftUI
import SwiftData

enum Weekday: Int, CaseIterable {
    case monday = 0, tuesday, wednesday, thursday, friday
    var title: String {
        ["월","화","수","목","금"][rawValue]
    }
}

@Observable
class TimetableViewModel {
    var isTimetableLoading: Bool = true
    var isTimetableEmpty: Bool = false
    
    var entries: [TimetableEntry] = TimetableEntry.sampleTimetable
    var baseEntries: [TimetableEntry]?
    
    var lastSubjects: [Subject] = []
    
    var selectedGrade: Int {
        get {
            access(keyPath: \.selectedGrade)
            return UserDefaults.standard.object(forKey: "selectedGrade") as? Int ?? 1
        }
        set {
            withMutation(keyPath: \.selectedGrade) {
                UserDefaults.standard.set(newValue, forKey: "selectedGrade")
                Task {
                    await fetchTimetable(containing: Date())
                }
            }
        }
    }
    var selectedClass: Int {
        get {
            access(keyPath: \.selectedClass)
            return UserDefaults.standard.object(forKey: "selectedClass") as? Int ?? 1
        }
        set {
            withMutation(keyPath: \.selectedClass) {
                UserDefaults.standard.set(newValue, forKey: "selectedClass")
                Task {
                    await fetchTimetable(containing: Date())
                }
            }
        }
    }
    
    // Rebuilds `entries` by overlaying subject selections on top of `baseEntries`.
    @MainActor
    func rebuildEntries(editingOverride: (id: Subject.ID?, name: String, selections: [SubjectSelection])? = nil) {
        let base = baseEntries ?? TimetableEntry.sampleTimetable
        entries = Self.buildEntries(
            subjects: lastSubjects,
            base: base,
            editingOverride: editingOverride
        )
    }

    // Pure calculation logic moved from view into the view model for cohesion
    private static func buildEntries(
        subjects: [Subject],
        base: [TimetableEntry],
        editingOverride: (id: Subject.ID?, name: String, selections: [SubjectSelection])? = nil
    ) -> [TimetableEntry] {
        var selectionMap: [String: String] = [:]

        for s in subjects {
            if let override = editingOverride, s.id == override.id {
                for sel in override.selections {
                    let key = "\(sel.dayRaw)-\(sel.period)"
                    selectionMap[key] = override.name
                }
            } else {
                for sel in s.selections {
                    let key = "\(sel.dayRaw)-\(sel.period)"
                    selectionMap[key] = s.name
                }
            }
        }

        if let override = editingOverride, override.id == nil {
            for sel in override.selections {
                let key = "\(sel.dayRaw)-\(sel.period)"
                selectionMap[key] = override.name
            }
        }

        return base.map { baseEntry in
            let key = "\(baseEntry.day.rawValue)-\(baseEntry.period)"
            if let name = selectionMap[key] {
                return TimetableEntry(day: baseEntry.day, period: baseEntry.period, subject: name)
            } else {
                return baseEntry
            }
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
        self.baseEntries = entries
        self.rebuildEntries()
    }
}

