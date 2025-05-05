//
//  MealListViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 5/2/25.
//

import Foundation

class MealListViewModel: ObservableObject {
    private let selectedAllergies = Set(UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? [])
    
    func attributedMenuList(for menus: [Menu]?) -> AttributedString {
        var result = AttributedString()
        
        guard let menus = menus else {
            return AttributedString("급식 정보가 없습니다.")
        }
        
        for (i, menu) in menus.enumerated() {
            var substr = AttributedString(menu.name)
            
            if let list = menu.allergies, !Set(list).isDisjoint(with: selectedAllergies) {
                substr.foregroundColor = .red
            }
            
            result.append(substr)
            
            if i < menus.count - 1 {
                result.append(AttributedString(", "))
            }
        }
        
        return result
    }
}
