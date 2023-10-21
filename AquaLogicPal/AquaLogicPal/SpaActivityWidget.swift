//import SwiftUI
//import WidgetKit
//
//@available(iOSApplicationExtension 16.1, *)
//struct SpaActivityWidget: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: FastingAttributes.self) { context in
//            LiveActivityView(context: context)
//                .padding(.horizontal)
//        } dynamicIsland: { context in
//            DynamicIsland {
//                DynamicIslandExpandedRegion(.leading) {
//                    LiveActivityView(context: context)
//                }
//            } compactLeading: {
//                Image(systemName: "circle")
//                    .foregroundColor(.green)
//            } compactTrailing: {
//                Text(verbatim: context.state.progress.formatted(.percent.precision(.fractionLength(0))))
//                    .foregroundColor(context.state.stage?.color)
//            } minimal: {
//                Image(systemName: "circle")
//                    .foregroundColor(.green)
//            }
//        }
//    }
//}
