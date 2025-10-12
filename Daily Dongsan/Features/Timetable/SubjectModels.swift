//
//  SubjectModels.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/9/25.
//

import Foundation
import SwiftData

@Model
final class Subject {
    @Attribute(.unique) private(set) var id = UUID()
    var name: String
    @Relationship(deleteRule: .cascade)
    var selections: [SubjectSelection]
    
    init(name: String, selections: [SubjectSelection] = []) {
        self.name = name
        self.selections = selections
    }
}

@Model
final class SubjectSelection {
    @Attribute(.unique) private(set) var id = UUID()
    var dayRaw: Int
    var period: Int
    
    var day: Weekday {
        Weekday(rawValue: dayRaw) ?? .monday
    }
    
    init(dayRaw: Int, period: Int) {
        self.dayRaw = dayRaw
        self.period = period
    }
    
    convenience init(day: Weekday, period: Int) {
        self.init(dayRaw: day.rawValue, period: period)
    }
}
