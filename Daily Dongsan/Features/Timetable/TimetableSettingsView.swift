//
//  TimetableSettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 8/20/25.
//

import SwiftUI

class TimetableSettingsViewModel: ObservableObject {
    @Published var selectedGrade: Int = 1
    @Published var selectedClass: Int = 1
    
    
}

struct TimetableSettingsView: View {
    @StateObject private var viewModel = TimetableSettingsViewModel()
    
    var body: some View {
        List {
            Section {
                Picker("학년", selection: $viewModel.selectedGrade) {
                    ForEach(1..<4) { grade in
                        Text("\(grade)학년").tag(grade)
                    }
                }
                
                Picker("반", selection: $viewModel.selectedClass) {
                    ForEach(1..<11) { `class` in
                        Text("\(`class`)반").tag(`class`)
                    }
                }
            }
            
            Section {
                NavigationLink("선택과목 설정") {
                    EmptyView()
                }
            }
        }
        .navigationTitle("시간표 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TimetableSettingsView()
}
