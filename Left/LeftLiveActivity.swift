//
//  LeftLiveActivity.swift
//  Left
//
//  Created by Angel Hernández Gámez on 23/07/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LeftAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LeftLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LeftAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LeftAttributes {
    fileprivate static var preview: LeftAttributes {
        LeftAttributes(name: "World")
    }
}

extension LeftAttributes.ContentState {
    fileprivate static var smiley: LeftAttributes.ContentState {
        LeftAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LeftAttributes.ContentState {
         LeftAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LeftAttributes.preview) {
   LeftLiveActivity()
} contentStates: {
    LeftAttributes.ContentState.smiley
    LeftAttributes.ContentState.starEyes
}
