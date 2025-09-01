//
//  TimetableView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 7/20/25.
//

import SwiftUI

struct TimetableView: View {
    @StateObject private var viewModel = TimetableViewModel()
    private let weekdays = Weekday.allCases
    @State private var maxRowHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.isTimetableLoading {
                        ProgressView()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Grid {
                            GridRow {
                                Text("")
                                ForEach(weekdays, id: \.self) {day in
                                    Text(day.title)
                                }
                            }
                            .font(.system(.subheadline, weight: .semibold))
                            
                            Divider()
                            
                            ForEach(1...7, id: \.self) { period in
                                GridRow {
                                    Text("\(period)")
                                        .fontWeight(.semibold)
                                    ForEach(weekdays, id: \.self) { day in
                                        Text(viewModel.subject(for: day, period: String(period)))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.center)
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
                                
                                if period < 7 {
                                    Divider()
                                }
                            }
                        }
                        .onPreferenceChange(MaxRowHeightKey.self) { value in
                            maxRowHeight = value
                        }
                    }
                }
                
                Section {
                    NavigationLink("시간표 설정") {
                        TimetableSettingsView()
                    }
                }
            }
            .navigationTitle("시간표")
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
    TimetableView()
}
