//
//  HapticViewModel.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 24/07/25.
//

import UIKit

class HapticViewModel {
    static let shared: HapticViewModel = HapticViewModel()
    
    private init() {}
    
    func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(type)
    }
}
