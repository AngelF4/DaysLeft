//
//  DayRow.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 24/07/25.
//

import SwiftUI

struct DayRow: View {
    let day: DayModel
    @Binding var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(day.daysUntilTarget.formatted()) days left")
                .font(.largeTitle.bold())
            Text(day.name)
                .font(.headline)
        }
        .foregroundStyle(day.daysUntilTarget <= 0 ? .secondary : .primary)
        .padding(.vertical, 12)
        .listRowBackground(Color.clear)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                viewModel.pinAndUnpinDay(day)
            } label: {
                Label(day.isPinned ? "Unpin" :"Pin", systemImage: day.isPinned ? "pin.slash" :"pin")
            }
            .tint(day.isPinned ? .gray : .orange)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.delete(day: day)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                viewModel.showUpdateFrom(day)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(Color.accentColor)
        }
        .contextMenu {
            Button {
                viewModel.pinAndUnpinDay(day)
            } label: {
                Label(day.isPinned ? "Unpin" :"Pin", systemImage: day.isPinned ? "pin.slash" :"pin")
            }
            Button {
                viewModel.showUpdateFrom(day)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button(role: .destructive) {
                viewModel.delete(day: day)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

//#Preview {
//    DayRow(day: DayModel(name: "Nombre", targetDate: .now), viewModel: .constant(ViewModel()))
//}
