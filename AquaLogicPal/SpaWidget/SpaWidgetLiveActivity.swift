import ActivityKit
import WidgetKit
import SwiftUI

struct SpaWidgetAttributes: ActivityAttributes {
    public typealias SpaStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var temp: Int
        var startTime: Date
    }

    var name: String
}

struct SpaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SpaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Spa Temp: \(context.state.temp)°")
            }
            .activityBackgroundTint(.dragoonBlue)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(.hotTub)
                        .resizable()
                        .frame(width: 44.0, height: 44.0)
                        .foregroundStyle(.cyan)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text("\(context.state.temp)°")
                            .font(.title)
                    }
                    .padding(.top, 8)
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack(alignment: .center) {
                        Text("Spa is heating...")
                            .font(.title)
                    }
                }
            } compactLeading: {
                Image(.hotTub)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.cyan)
            } compactTrailing: {
                Text("\(context.state.temp)°")
            } minimal: {
                Image(.hotTub)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.cyan)
            }
            .keylineTint(.dragoonBlue)
        }
    }
}

extension SpaWidgetAttributes {
    fileprivate static var preview: SpaWidgetAttributes {
        SpaWidgetAttributes(name: "Spa")
    }
}

extension SpaWidgetAttributes.SpaStatus {
    fileprivate static var notHot: SpaWidgetAttributes.SpaStatus {
        SpaWidgetAttributes.SpaStatus(temp: 90, startTime: Date.now)
     }
     
     fileprivate static var hot: SpaWidgetAttributes.SpaStatus {
         SpaWidgetAttributes.SpaStatus(temp: 100, startTime: Date.now)
     }
}

#Preview("Notification", as: .content, using: SpaWidgetAttributes.preview) {
   SpaWidgetLiveActivity()
} contentStates: {
    SpaWidgetAttributes.SpaStatus.notHot
    SpaWidgetAttributes.SpaStatus.hot
}
