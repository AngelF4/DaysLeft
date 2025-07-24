//
//  ContentView.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                }
                Section(viewModel.daysPinned.isEmpty ? "": "Pinned") {
                    ForEach(viewModel.daysPinned, id: \.id) { day in
                        DayRow(day: day,
                               viewModel: $viewModel)
                    }
                    if !viewModel.daysPinned.isEmpty {
                        Spacer(minLength: 20) //Para una separación clara
                            .listRowBackground(Color.clear)
                    }
                }
                Section {
                    ForEach(viewModel.daysUnpinned, id: \.id) { day in
                        DayRow(day: day,
                               viewModel: $viewModel)
                    }
                }
            }
            .monospaced()
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color("darkBackground"))
            .navigationTitle("Days Left")
            .toolbar {
                Button {
                    viewModel.showForm = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .bold()
                }
            }
            .overlay {
                if viewModel.days.isEmpty {
                    ContentUnavailableView("There are no days to show yet.", systemImage: "ellipsis")
                        .monospaced()
                }
            }
            .sheet(isPresented: $viewModel.showForm) {
                viewModel.cleanFields()
            } content: {
                NavigationStack {
                    NewDate(viewModel: $viewModel)
                }
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    let container = try! ModelContainer(for: DayModel.self)
    let context = ModelContext(container)
    return ContentView(modelContext: context)
        .modelContainer(container)
}
