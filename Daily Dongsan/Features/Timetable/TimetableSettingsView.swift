//
//  TimetableSettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 8/20/25.
//

import SwiftUI

struct SubjectSettingsView: View {
    @EnvironmentObject private var viewModel: TimetableViewModel
    
    @State private var subjects: [String] = ["공강", "예배"]
    
    var body: some View {
        List {
            ForEach($subjects, id: \.self) { $subject in
                NavigationLink(subject) {
                    EditSubjectView(subject: $subject)
                        .environmentObject(viewModel)
                }
            }
            .onDelete { indexSet in
                subjects.remove(atOffsets: indexSet)
            }
        }
        .toolbar {
            EditButton()
            NavigationLink {
                AddSubjectView(subjects: $subjects)
            } label: {
                Label("추가", systemImage: "plus")
            }
        }
        .navigationTitle("과목 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private struct AddSubjectView: View {
        @Environment(\.dismiss) private var dismiss
        
        @Binding var subjects: [String]
        @State private var name = ""
        
        var body: some View {
            List {
                Section {
                    TextField("과목명", text: $name)
                }
            }
            .navigationTitle("과목 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("저장") {
                    if !name.isEmpty {
                        subjects.append(name)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
            }
        }
    }
    
    private struct EditSubjectView: View {
        @EnvironmentObject private var viewModel: TimetableViewModel
        
        @Binding var subject: String
        
        @State private var selectedEntries: [TimetableEntry] = []

        var body: some View {
            List {
                Section {
                    TextField("과목명", text: $subject)
                }
                
                Section {
                    TimetableGridView(
                        entries: !viewModel.isTimetableEmpty ? viewModel.entries : TimetableEntry.sampleTimetable,
                        onCellTap: { day, period in
                            let entry = TimetableEntry(day: day, period: period, subject: subject)
                            
                            if let idx = selectedEntries.firstIndex(where: { $0.day == day && $0.period == period }) {
                                selectedEntries.remove(at: idx)
                            } else {
                                selectedEntries.append(entry)
                            }
                            
                            print(selectedEntries)
                        }
                    )
                }
            }
            .navigationTitle(subject)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SubjectSettingsView()
}

