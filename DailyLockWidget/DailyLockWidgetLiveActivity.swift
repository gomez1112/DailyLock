//
//  DailyLockWidgetLiveActivity.swift
//  DailyLockWidget
//
//  Created by Gerard Gomez on 8/23/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DailyLockWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DailyLockWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyLockWidgetAttributes.self) { context in
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

extension DailyLockWidgetAttributes {
    fileprivate static var preview: DailyLockWidgetAttributes {
        DailyLockWidgetAttributes(name: "World")
    }
}

extension DailyLockWidgetAttributes.ContentState {
    fileprivate static var smiley: DailyLockWidgetAttributes.ContentState {
        DailyLockWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DailyLockWidgetAttributes.ContentState {
         DailyLockWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DailyLockWidgetAttributes.preview) {
   DailyLockWidgetLiveActivity()
} contentStates: {
    DailyLockWidgetAttributes.ContentState.smiley
    DailyLockWidgetAttributes.ContentState.starEyes
}
