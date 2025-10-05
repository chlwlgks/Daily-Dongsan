//
//  AllergyView.swift
//  geubchelin
//
//  Created by 최지한 on 1/25/25.
//

import SwiftUI

struct AllergySelectionView: View {
    @EnvironmentObject private var viewModel: AllergySelectionViewModel
    
    var body: some View {
        List(viewModel.allergies) { allergy in
            Button {
                viewModel.toggleSelection(for: allergy.id)
                HapticManager.instance.selection()
            } label: {
                HStack {
                    Text("\(allergy.id). \(allergy.name)")
                    Spacer()
                    if viewModel.selectedAllergies.contains(allergy.id) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("알레르기 유발 식품 선택")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AllergySelectionView()
}
