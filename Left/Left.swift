//
//  Left.swift
//  Left
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: AppIntentTimelineProvider {
    typealias Intent = SelectDayIntent
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 5))!,
            day: DayModelEntity(id: UUID(), name: "Example", targetDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 15))!)
        )
    }
    
    func snapshot(for configuration: SelectDayIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: .now, day: configuration.day)
    }
    
    func timeline(for configuration: SelectDayIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let selectedDay = configuration.day
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, day: selectedDay)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let day: DayModelEntity?
}

struct LeftEntryView : View {
    @Environment(\.widgetFamily) private var family
    let viewModel = WidgetViewModel()
    
    var daysInMonth: Int {
        viewModel.getDays(in: entry.date)
    }
    
    var dayleft: Int {
        guard let target = entry.day?.targetDate else { return 0 }
        return viewModel.daysBetween(entry.date, and: target)
    }
    let entry: Provider.Entry
    private var yearDay: Int {
        Int((dayleft/30)/12) + 3
    }
    
    private var smallBody: some View {
        VStack(alignment: .leading) {
            if let day = entry.day {
                WidgetTitles(day: day, dayleft: dayleft)
            } else {
                Text("Select a day")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            WidgetCalendar(dayleft: dayleft, daysInMonth: daysInMonth)
        }
    }
    
    private var mediumBody: some View {
        HStack(alignment: .top) {
            if let day = entry.day {
                WidgetTitles(day: day, dayleft: dayleft, isMedium: true)
            } else {
                Text("Select a day")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            Spacer()
            WidgetCalendar(dayleft: dayleft, daysInMonth: daysInMonth)
        }
    }
    
    var body: some View {
        Group {
            switch family {
                case .systemMedium:
                    mediumBody
                default:
                    smallBody
            }
        }
        .padding(.vertical, 12)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct Left: Widget {
    let kind: String = "Left"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectDayIntent.self, provider: Provider()) { entry in
            LeftEntryView(entry: entry)
                .containerBackground(Color("WidgetBackground"), for: .widget)
        }
        .configurationDisplayName("Days Remaining Counter")
        .description("A calendar that shows the number of days remaining until a specified date.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}



#Preview(as: .systemSmall) {
    Left()
} timeline: {
    SimpleEntry(date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
                day: DayModelEntity(id: UUID(), name: "Example", targetDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 1))!))
    SimpleEntry(date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 5))!,
                day: DayModelEntity(id: UUID(), name: "Example", targetDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 15))!))
    
    SimpleEntry(date: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 10))!,
                day: DayModelEntity(id: UUID(), name: "Example", targetDate: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 25))!))
}
