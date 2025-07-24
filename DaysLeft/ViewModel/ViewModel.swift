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
    let defaults = UserDefaults(suiteName: "group.com.hega.tuapp")
    
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
            
            // Eliminar días con targetDate en el pasado
            let now = Calendar.current.startOfDay(for: .now)
            let expiredDays = days.filter { $0.targetDate < now }
            for expired in expiredDays {
                modelContext.delete(expired)
            }
            
            // Guardar cambios después de eliminar
            if !expiredDays.isEmpty {
                try modelContext.save()
            }
            
            // Actualizar lista después de eliminar
            days = days.filter { $0.targetDate >= now }
            
            // Ordenar días actualizados
            days.sort { $0.daysUntilTarget < $1.daysUntilTarget }
            
        } catch {
            self.error = "No se pudo cargar la lista de días"
            HapticViewModel.shared.vibrate(type: .error)
            print("Fetch failed")
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
            self.error = "No se pudo guardar el día"
            fatalError("No se pudo guardar el día")
        }
    }
    
    func updateDay() {
        guard let name = daySelected?.name as? String else { return }
        guard let index = days.firstIndex(of: days.first(where: { $0.name == name })!) else { return }
        days[index].name = name
        days[index].targetDate = targetDate
        do {
            try modelContext.save()
            fetchData()
            cleanFields()
            HapticViewModel.shared.vibrate(type: .success)
            showForm = false
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            self.error = "No se pudo guardar el día"
            HapticViewModel.shared.vibrate(type: .error)
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
}
