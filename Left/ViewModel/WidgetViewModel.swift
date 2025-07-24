//
//  WidgetViewModel.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 24/07/25.
//

import Foundation

class WidgetViewModel {
    func getDays(in month: Date) -> Int {
        let calendar = Calendar.current
        
        if let range = calendar.range(of: .day, in: .month, for: month) {
            return range.count
        }
        return 0
    }
    
    func daysBetween(_ start: Date, and end: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: start)
        let endOfDay = calendar.startOfDay(for: end)
        
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
        return components.day ?? 0
    }
}
