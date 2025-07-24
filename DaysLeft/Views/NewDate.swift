//
//  NewDate.swift
//  DaysLeft
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import SwiftUI

struct NewDate: View {
    @Binding var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Nombre", text: $viewModel.name, axis: .vertical)
                    .font(.title.bold())
                    .submitLabel(.next)
                DatePicker("Fecha objetivo", selection: $viewModel.targetDate, in: Date()..., displayedComponents: [.date])
                if let error = viewModel.error {
                    Text(error).foregroundColor(.red)
                }
            }
            .monospaced()
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Nueva fecha").monospaced().bold()
            }
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.daySelected != nil {
                    Button {
                        viewModel.updateDay()
                    } label: {
                        Image(systemName: "pencil")
                    }
                } else {
                    Button {
                        viewModel.createDay()
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                    }
                }
                
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        NewDate(viewModel: ViewModel())
//    }
//}
