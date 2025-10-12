//
//  TimetableView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 7/20/25.
//

import SwiftUI
import SwiftData

struct TimetableView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var hasLoadedInitialTimetable = false
    
    @State private var viewModel = TimetableViewModel()
    @Query(sort: \Subject.name) private var subjects: [Subject]
    
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
                    
//                    NavigationLink("과목 설정") {
//                        SubjectSettingsView()
//                            .environment(viewModel)
//                    }
                }
            }
            .navigationTitle("시간표")
            .applyNavigationSubtitleIfAvailable("\(viewModel.selectedGrade)학년 \(viewModel.selectedClass)반")
            .task {
                if !hasLoadedInitialTimetable {
                    viewModel.lastSubjects = subjects
                    await viewModel.fetchTimetable(containing: Date())
                    hasLoadedInitialTimetable = true
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }
                viewModel.lastSubjects = subjects
                Task {
                    await viewModel.fetchTimetable(containing: Date())
                }
            }
        }
    }
}

#Preview {
    TimetableView()
}
