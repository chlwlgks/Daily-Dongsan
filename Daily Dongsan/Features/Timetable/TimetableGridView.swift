//
//  TimetableGridView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/5/25.
//

import SwiftUI

struct TimetableGridView: View {
    private let weekdays = Weekday.allCases
    
    let entries: [TimetableEntry]
    let onCellTap: ((Weekday, Int) -> Void)?

    init(entries: [TimetableEntry], onCellTap: ((Weekday, Int) -> Void)? = nil) {
        self.entries = entries
        self.onCellTap = onCellTap
    }

    private var maxPeriod: Int {
        entries.compactMap { $0.period }.max() ?? 7
    }
    private func subject(for day: Weekday, period: Int) -> String {
        return entries.first { $0.day == day && $0.period == period }?.subject ?? ""
    }
    
    @State private var maxRowHeight: CGFloat = 0

    var body: some View {
        Grid {
            GridRow {
                Text("")
                ForEach(weekdays, id: \.self) { day in
                    Text(day.title)
                }
            }
            .font(.subheadline.weight(.semibold))

            Divider()

            ForEach(1...maxPeriod, id: \.self) { period in
                GridRow {
                    Text("\(period)")
                        .fontWeight(.semibold)
                    ForEach(weekdays, id: \.self) { day in
                        Text(subject(for: day, period: period))
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                            .contentShape(Rectangle()) // 탭 영역 확장
                            .onTapGesture {
                                onCellTap?(day, period)
                            }
                    }
                }
                .font(.subheadline)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: MaxRowHeightKey.self, value: proxy.size.height)
                    }
                )
                .frame(height: maxRowHeight)

                if period < maxPeriod {
                    Divider()
                }
            }
        }
        .onPreferenceChange(MaxRowHeightKey.self) { value in
            maxRowHeight = value
        }
    }
}

private struct MaxRowHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    TimetableGridView(entries: TimetableEntry.sampleTimetable)
}

