//
//  AllergySelectionViewModel.swift
//  geubchelin
//
//  Created by 최지한 on 1/28/25.
//

import Foundation

struct Allergy: Identifiable {
    let id: String
    let name: String
}

class AllergySelectionViewModel: ObservableObject {
    let allergies = [
            Allergy(id: "1", name: "알류"),
            Allergy(id: "2", name: "우유"),
            Allergy(id: "3", name: "메밀"),
            Allergy(id: "4", name: "땅콩"),
            Allergy(id: "5", name: "대두"),
            Allergy(id: "6", name: "밀"),
            Allergy(id: "7", name: "고등어"),
            Allergy(id: "8", name: "게"),
            Allergy(id: "9", name: "새우"),
            Allergy(id: "10", name: "돼지고기"),
            Allergy(id: "11", name: "복숭아"),
            Allergy(id: "12", name: "토마토"),
            Allergy(id: "13", name: "아황산염"),
            Allergy(id: "14", name: "호두"),
            Allergy(id: "15", name: "닭고기"),
            Allergy(id: "16", name: "쇠고기"),
            Allergy(id: "17", name: "오징어"),
            Allergy(id: "18", name: "조개류(굴, 전복, 홍합)"),
            Allergy(id: "19", name: "잣")
        ]
    
    private let key = "SelectedAllergies"
    
    @Published var selectedAllergies: Set<String> = [] {
        didSet {
            let ids = Array(selectedAllergies)
            UserDefaults.standard.set(ids, forKey: key)
        }
    }
    
    init() {
        let ids = UserDefaults.standard.array(forKey: key) as? [String] ?? []
        selectedAllergies = Set(ids)
    }
    
    func toggleSelection(for allergyID: String) {
        if selectedAllergies.contains(allergyID) {
            selectedAllergies.remove(allergyID)
        } else {
            selectedAllergies.insert(allergyID)
        }
    }
}
