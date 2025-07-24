//
//  WidgetCalendar.swift
//  LeftExtension
//
//  Created by Angel Hernández Gámez on 24/07/25.
//

import SwiftUI

struct WidgetCalendar: View {
    let dayleft: Int
    let daysInMonth: Int
    
    private var yearDay: Int {
        Int((dayleft/30)/12) + 3
    }
    
    private let gridDay: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let gridMonths: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let gridYear: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        if dayleft > 365 {
            LazyVGrid(columns: gridYear) {
                ForEach(1...yearDay, id: \.self) { index in
                    Circle()
                        .fill(index > Int((dayleft/30)/12) ? .gray : .white)
                        .frame(width: 25)
                }
            }
        } else if dayleft > 31 {
            LazyVGrid(columns: gridMonths) {
                ForEach(1...12, id: \.self) { index in
                    Circle()
                        .fill(index > Int(dayleft/30) ? .gray : .white)
                        .frame(width: 22)
                }
            }
        } else {
            LazyVGrid(columns: gridDay) {
                ForEach(1...daysInMonth, id: \.self) { index in
                    Circle()
                        .fill(index > dayleft ? .gray : .white)
                        .frame(width: 10)
                }
            }
        }
    }
}

#Preview {
    WidgetCalendar(dayleft: 9, daysInMonth: 9)
}
