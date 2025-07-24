//
//  AppIntent.swift
//  Left
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import WidgetKit
import AppIntents
import SwiftData

/// Wrapper to expose DayModel to App Intents
struct DayModelEntity: AppEntity {
    let id: UUID
    let name: String
    let targetDate: Date
    
    static var defaultQueryLimit: Int = 50
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Día")
    static var defaultQuery: DayModelQuery = DayModelQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }
}

/// Query to load DayModelEntity instances from SwiftData
struct DayModelQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [DayModelEntity] {
        let container = try ModelContainer(for: DayModel.self)
        let ctx = ModelContext(container)
        let desc = FetchDescriptor<DayModel>(predicate: #Predicate { identifiers.contains($0.id) })
        let models = try ctx.fetch(desc)
        return models.map {
            DayModelEntity(id: $0.id, name: $0.name, targetDate: $0.targetDate)
        }
    }
    
    func suggestedEntities() async throws -> [DayModelEntity] {
        let container = try ModelContainer(for: DayModel.self)
        let ctx = ModelContext(container)
        let desc = FetchDescriptor<DayModel>(sortBy: [SortDescriptor(\.targetDate)])
        let models = try ctx.fetch(desc)
        return models.map {
            DayModelEntity(id: $0.id, name: $0.name, targetDate: $0.targetDate)
        }
    }
    
    func defaultResult() async -> DayModelEntity? {
        (try? await suggestedEntities())?.first
    }
}

struct SelectDayIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Seleccionar Día")
    
    @Parameter(title: "Fecha mostrada", query: DayModelQuery())
    var day: DayModelEntity?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Día: \(\.$day)")
    }
    
    func perform() async throws -> some IntentResult {
        .result()
    }
}
