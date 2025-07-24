//
//  ViewModel.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import SwiftData
import SwiftUI
import Foundation
import WidgetKit

@Observable
class ViewModel {
    var targetDate: Date = .now
    var name: String = ""
    var showForm = false
    var error: String?
    var days: [DayModel] = []
    var daySelected: DayModel?
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    var daysPinned: [DayModel] {
        days.filter(\.isPinned)
            .sorted { $0.daysUntilTarget < $1.daysUntilTarget }
    }
    
    var daysUnpinned: [DayModel] {
        days.filter { !$0.isPinned }
            .sorted { $0.daysUntilTarget < $1.daysUntilTarget }
    }
    
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<DayModel>(sortBy: [SortDescriptor(\.targetDate)])
            days = try modelContext.fetch(descriptor)
            
            // Delete days with targetDate in the past
            let now = Calendar.current.startOfDay(for: .now)
            let expiredDays = days.filter { $0.targetDate < now }
            for expired in expiredDays {
                modelContext.delete(expired)
            }
            
            // Save changes after deletion
            if !expiredDays.isEmpty {
                try modelContext.save()
            }
            
            // Update list after deletion
            days = days.filter { $0.targetDate >= now }
            
            // Sort updated days
            days.sort { $0.daysUntilTarget < $1.daysUntilTarget }
            
        } catch {
            makeError("Failed to load days list", error: error)
        }
    }
    
    func createDay() {
        let newDay = DayModel(name: name, targetDate: targetDate)
        modelContext.insert(newDay)
        HapticViewModel.shared.vibrate(type: .success)
        fetchData()
        cleanFields()
        showForm = false
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func showUpdateFrom(_ day: DayModel) {
        daySelected = day
        name = day.name
        targetDate = day.targetDate
        showForm = true
    }
    
    func pinAndUnpinDay(_ day: DayModel) {
        withAnimation {
            day.isPinned.toggle()
        }
        do {
            try modelContext.save()
            fetchData()
        } catch {
            makeError("Failed to save the day", error: error)
        }
    }
    
    func updateDay() {
        guard let day = daySelected else { return }
        day.name = name
        day.targetDate = targetDate
        
        do {
            try modelContext.save()
            fetchData()
            cleanFields()
            HapticViewModel.shared.vibrate(type: .success)
            showForm = false
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            makeError("Failed to save the day", error: error)
        }
    }
    
    func delete(day: DayModel) {
        modelContext.delete(day)
        fetchData()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension ViewModel {
    //MARK: helpers
    func cleanFields() {
        name = ""
        error = nil
        daySelected = nil
        targetDate = .now
    }
    func makeError(_ message: String, error: Error) {
        self.error = message
        HapticViewModel.shared.vibrate(type: .error)
#if DEBUG
        print(error.localizedDescription)
#endif
    }
}
