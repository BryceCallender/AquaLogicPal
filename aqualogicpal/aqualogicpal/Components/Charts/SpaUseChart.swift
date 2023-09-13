//https://github.com/jordibruin/Swift-Charts-Examples

import SwiftUI
import Charts

struct SpaUseChart: View {
    var isOverview: Bool
    
    @State private var barWidth = 7.0
    
    @State private var data: [SpaData] = [
        .init(eventTime: Date.now, count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: 1), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: 2), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: 3), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: 4), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -1), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -2), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -3), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -4), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -5), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -6), count: Int.random(in: 0..<20)),
        .init(eventTime: addOrSubtractMonth(month: -7), count: Int.random(in: 0..<20)),
    ]
    
    let gradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .init(hex: "#993BF5")!,
                //.init(hex: "#0649A5")!,
                .init(hex: "#41ADF5")!,
                .init(hex: "#05D1D8")!,
                .init(hex: "#05D888")!,
            ]
        ),
        startPoint: .bottom,
        endPoint: .top
    )
    
    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle("Spa Uses", displayMode: .inline)
//            .onAppear {
//                for index in data.indices {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
//                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
//                            data[index].sales = SalesData.last30Days[index].sales
//                        }
//                    }
//                }
//            }
        }
    }
    
    private var chart: some View {
        Chart(data) { dataPoint in
            BarMark(
                x: .value("Month", dataPoint.eventTime, unit: .month),
                y: .value("Total Count", dataPoint.count),
                width: isOverview ? .automatic : .fixed(barWidth)
            )
            .accessibilityLabel(dataPoint.eventTime.formatted(date: .complete, time: .omitted))
            .accessibilityValue("\(dataPoint.count) times")
            .accessibilityHidden(isOverview)
            .foregroundStyle(.dragoonBlue.gradient)
            
//            if isOverview {
//                RuleMark(
//                    y: .value("Average", 10)
//                )
//                .lineStyle(StrokeStyle(lineWidth: 5))
//                .foregroundStyle(.dragoonBlue)
//                .annotation(position: .top, alignment: .leading) {
//                    Text("Average Uses")
//                        .accessibilityLabel("Average")
//                        .font(.caption.bold())
//                        .foregroundStyle(.secondary)
//                }
//                .annotation(position: .bottom, alignment: .leading) {
//                    Text("10")
//                        .font(.title3.bold()) + Text(" uses").font(.callout).foregroundStyle(.secondary)
//                }
//            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: Calendar.Component.month)) { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.narrow))
            }
        }
        //.accessibilityChartDescriptor(self)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
}

// MARK: - Accessibility

//extension SpaUseChart: AXChartDescriptorRepresentable {
//    func makeChartDescriptor() -> AXChartDescriptor {
//        AccessibilityHelpers.chartDescriptor(forSalesSeries: data)
//    }
//}

struct SpaUseChartView_Previews: PreviewProvider {
    static var previews: some View {
        SpaUseChart(isOverview: true)
        SpaUseChart(isOverview: false)
    }
}
