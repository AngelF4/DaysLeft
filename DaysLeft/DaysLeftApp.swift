//
//  DaysLeftApp.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import SwiftUI
import SwiftData

@main
struct DaysLeftApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(for: DayModel.self)
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 34, weight: .bold)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 17, weight: .bold)
        ]
        
        do {
            container = try ModelContainer(for: DayModel.self)
        } catch {
            fatalError("Failed to create ModelContainer for DayModel.")
        }
    }
}
