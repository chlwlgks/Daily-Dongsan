//
//  TimetableView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 7/20/25.
//

import SwiftUI

struct TimetableView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = TimetableViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.isTimetableEmpty {
                        Text("시간표 정보가 없습니다.")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        TimetableGridView(entries: viewModel.entries)
                            .applyIf(viewModel.isTimetableLoading) { view in
                                view.hidden()
                                    .overlay {
                                        ProgressView()
                                            .id(UUID())
                                    }
                            }
                    }
                }
                
                Section {
                    Picker("학년", selection: $viewModel.selectedGrade) {
                        ForEach(1...3, id: \.self) { grade in
                            Text("\(grade)학년")
                                .tag(grade)
                        }
                    }
                    Picker("반", selection: $viewModel.selectedClass) {
                        ForEach(1...12, id: \.self) { cls in
                            Text("\(cls)반")
                                .tag(cls)
                        }
                    }
                    
                    NavigationLink("과목 설정") {
                        SubjectSettingsView()
                            .environmentObject(viewModel)
                    }
                    .disabled(true)
                } footer: {
                    Text("과목 설정은 iOS 17 이상에서 지원됩니다.")
                }
            }
            .navigationTitle("시간표")
            .applyNavigationSubtitleIfAvailable("\(viewModel.selectedGrade)학년 \(viewModel.selectedClass)반")
            .onChange(of: scenePhase) { newValue in
                Task {
                    if newValue == .active {
                        await viewModel.fetchTimetable(containing: Date())
                    }
                }
            }
        }
    }
}

#Preview {
    TimetableView()
}
