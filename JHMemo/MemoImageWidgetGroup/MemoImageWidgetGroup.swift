//
//  MemoImageWidgetGroup.swift
//  MemoImageWidgetGroup
//
//  Created by JH on 2021/01/31.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), relevance: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, relevance: nil, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
	let relevance: TimelineEntryRelevance?
    let configuration: ConfigurationIntent
}

struct MemoImageWidgetGroupEntryView: View {
    var entry: Provider.Entry

	@ViewBuilder
    var body: some View {
		Text("오늘은 무슨 일이 있었나요?")
			.fontWeight(.ultraLight)
			.font(.system(size: 20))
			.lineLimit(2)
			.frame(width: 140, height: 100)
			.padding()
    }
}

@main
struct MemoImageWidgetGroup: Widget {
    let kind: String = "MemoImageWidgetGroup"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MemoImageWidgetGroupEntryView(entry: entry)
        }
        .configurationDisplayName("지혜로운 메모")
        .description("This is an example widget.")
		.supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct MemoImageWidgetGroup_Previews: PreviewProvider {
    static var previews: some View {
        MemoImageWidgetGroupEntryView(entry: SimpleEntry(date: Date(), relevance: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
