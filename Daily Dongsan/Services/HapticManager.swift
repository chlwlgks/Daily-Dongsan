//
//  HapticManager.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/10/25.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    
    func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(notificationType)
    }
    
    func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
