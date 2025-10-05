//
//  ViewExtensions.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/5/25.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func applyNavigationSubtitleIfAvailable(_ subtitle: String) -> some View {
        if #available(iOS 26.0, *) {
            self.navigationSubtitle(subtitle)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
