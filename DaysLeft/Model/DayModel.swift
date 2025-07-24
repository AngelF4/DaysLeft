//
//  DayModel.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import AppIntents
import SwiftData

@Model
class DayModel {
    var id: UUID
    var name: String
    var targetDate: Date
    var isPinned: Bool
    
    init(id: UUID = UUID(), name: String, targetDate: Date, isPinned: Bool = false) {
        self.id = id
        self.name = name
        self.targetDate = targetDate
        self.isPinned = isPinned
    }
}

extension DayModel {
    var daysUntilTarget: Int {
        dayCount(from: .now)
    }
}

extension DayModel {
    func dayCount(from date: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.startOfDay(for: targetDate)
        
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
        return components.day ?? 0
    }
}
