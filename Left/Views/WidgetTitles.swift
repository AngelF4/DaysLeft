//
//  WidgetTitles.swift
//  LeftExtension
//
//  Created by Angel Hernández Gámez on 24/07/25.
//

import SwiftUI

struct WidgetTitles: View {
    let day: DayModelEntity
    let dayleft: Int
    var isMedium: Bool = false
    
    private var years: Int {
        dayleft / 365
    }
    private var months: Int {
        (dayleft % 365) / 30
    }
    private var daysRemaining: Int {
        dayleft % 30
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(day.name)
                .font(isMedium ? .title3 : .headline)
            Group {
                if years >= 1 {
                    Text("\(years) years left")
                    if isMedium {
                        Text("\(months) months, \(daysRemaining) days")
                    }
                } else if months >= 1 {
                    Text("\(months) months left")
                    if isMedium {
                        Text("\(daysRemaining) days")
                    }
                } else {
                    Text("\(dayleft.formatted()) days left")
                }
            }
            .font(isMedium ? .body : .footnote)
        }
        .foregroundStyle(.white)
        .monospaced().bold()
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
}

#Preview {
    WidgetTitles(day: DayModelEntity(id: UUID(), name: "ejemplo", targetDate: .now), dayleft: 9)
}
