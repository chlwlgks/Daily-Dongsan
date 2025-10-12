//
//  SubjectSettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 8/20/25.
//

import SwiftUI
import SwiftData

struct SubjectSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subject.name) private var subjects: [Subject]
    
    @Environment(TimetableViewModel.self) private var viewModel
    @AppStorage("didSeedDefaultSubjects") private var didSeedDefaultSubjects: Bool = false
    
    var body: some View {
        List {
            ForEach(subjects) { subject in
                NavigationLink(subject.name) {
                    SubjectEditorView(subject: subject)
                        .environment(viewModel)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let subject = subjects[index]
                    modelContext.delete(subject)
                }
            }
        }
        .navigationTitle("과목 설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
            NavigationLink {
                SubjectEditorView(subject: nil)
                    .environment(viewModel)
            } label: {
                Label("추가", systemImage: "plus")
            }
        }
        .task {
            if !didSeedDefaultSubjects {
                let worship = Subject(name: "예배", selections: [])
                let free = Subject(name: "공강", selections: [])
                modelContext.insert(worship)
                modelContext.insert(free)
                try? modelContext.save()
                didSeedDefaultSubjects = true
            }
        }
        .task(id: subjects) {
            viewModel.lastSubjects = subjects
            viewModel.rebuildEntries()
        }
    }
    
    private struct SubjectEditorView: View {
        @Environment(\.modelContext) private var modelContext
        @Environment(\.dismiss) private var dismiss
        @Query(sort: \Subject.name) private var subjects: [Subject]

        @Environment(TimetableViewModel.self) private var viewModel

        var subject: Subject?
        @State private var name: String = ""
        @State private var selections: [SubjectSelection] = []
        
        private func rebuildEntries() {
            withAnimation {
                viewModel.rebuildEntries(editingOverride: (id: subject?.id, name: name, selections: selections))
            }
        }

        private func isSelected(day: Weekday, period: Int) -> SubjectSelection? {
            return selections.first { $0.dayRaw == day.rawValue && $0.period == period }
        }
        @MainActor
        private func toggleSelection(day: Weekday, period: Int) {
            withAnimation {
                if let existing = isSelected(day: day, period: period) {
                    if let idx = selections.firstIndex(where: { $0.id == existing.id }) {
                        selections.remove(at: idx)
                    }
                } else {
                    selections.append(SubjectSelection(day: day, period: period))
                }
            }
            HapticManager.instance.selection()
            rebuildEntries()
        }

        var body: some View {
            List {
                Section {
                    TextField("과목명", text: $name)
                        .submitLabel(.done)
                        .onChange(of: name) { _, _ in
                            rebuildEntries()
                        }
                }
                Section {
                    TimetableGridView(
                        entries: viewModel.entries,
                        onCellTap: { day, period in
                            toggleSelection(day: day, period: period)
                        },
                        highlight: { day, period in
                            isSelected(day: day, period: period) != nil
                        },
                        maxPeriodLimit: 8
                    )
                } footer: {
                    Text("시간표의 칸을 탭해 이 과목이 들어갈 교시를 선택하세요. 다시 탭하면 해제됩니다.")
                }
            }
            .navigationTitle(subject == nil ? "과목 추가" : "과목 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("저장") {
                    if name.isEmpty { return }

                    if let subject {
                        subject.name = name
                        subject.selections = selections
                    } else {
                        let newSubject = Subject(name: name, selections: selections)
                        modelContext.insert(newSubject)
                    }

                    try? modelContext.save()
                    HapticManager.instance.notification(notificationType: .success)
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            .onAppear {
                if let subject {
                    name = subject.name
                    selections = subject.selections
                } else {
                    name = ""
                    selections = []
                }
                
                viewModel.lastSubjects = subjects
                rebuildEntries()
            }
        }
    }
}

#Preview {
    SubjectSettingsView()
        .modelContainer(for: Subject.self, inMemory: true)
}
