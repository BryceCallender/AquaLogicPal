//https://github.com/jordibruin/Swift-Charts-Examples

import SwiftUI
import Charts

func addOrSubtractMonth(month: Int) -> Date {
    Calendar.current.date(byAdding: .month, value: month, to: Date())!
}

struct SaltLevelRangeChart: View {
    var isOverview: Bool
    
    @State private var rawSelectedDate: Date?
    
    @State private var data: [SaltData] = [
        .init(eventTime: Date.now, salt: 2700, id: 1),
        .init(eventTime: addOrSubtractMonth(month: 1), salt: 3400, id: 2),
        .init(eventTime: addOrSubtractMonth(month: 2), salt: 2700, id: 3),
        .init(eventTime: addOrSubtractMonth(month: 3), salt: 2300, id: 4),
        .init(eventTime: addOrSubtractMonth(month: 4), salt: 2300, id: 5),
        .init(eventTime: addOrSubtractMonth(month: -1), salt: 2300, id: 6),
        .init(eventTime: addOrSubtractMonth(month: -2), salt: 2300, id: 7),
        .init(eventTime: addOrSubtractMonth(month: -3), salt: 2300, id: 8),
        .init(eventTime: addOrSubtractMonth(month: -4), salt: 2300, id: 9),
        .init(eventTime: addOrSubtractMonth(month: -5), salt: 2300, id: 10),
        .init(eventTime: addOrSubtractMonth(month: -6), salt: 2300, id: 11),
        .init(eventTime: addOrSubtractMonth(month: -7), salt: 2300, id: 12),
    ]
    
    @State private var barWidth = 10.0
    
    var selectedDateValue: (date: Date, salt: Double)? {
        if rawSelectedDate == nil {
            return nil
        }
        
        if let saltData = data.first(where: { Calendar.current.isDate($0.eventTime, equalTo: rawSelectedDate!, toGranularity: .month) }) {
            var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: saltData.eventTime)
            
            newComponents.day = 15
            let newDate = Calendar.current.date(from: newComponents) ?? Date.now
            
            return (newDate, saltData.salt)
        }
        
        return nil
    }
    
    var min: Double? {
        return data.min()?.salt
    }
    
    var max: Double? {
        return data.max()?.salt
    }
    
    var body: some View {
       if isOverview {
           chart
       } else {
           List {
               Section(header: header) {
                   chart
               }
           }
           .navigationBarTitle("Salt Level Range", displayMode: .inline)
       }
   }
    
    private var chart: some View {
        Chart(data) { dataPoint in
            Plot {
                BarMark(
                    x: .value("Month", dataPoint.eventTime, unit: .month),
                    yStart: .value("PPM Min", dataPoint.salt),
                    yEnd: .value("PPM Max", dataPoint.salt),
                    width: .fixed(isOverview ? 8 : barWidth)
                )
                .clipShape(.capsule)
                .foregroundStyle(.dragoonBlue.gradient)
                
                if let selectedDateValue {
                    RuleMark(
                        x: .value("Selected", selectedDateValue.date, unit: .day)
                    )
                    .foregroundStyle(.gray.opacity(0.3))
                    .offset(yStart: -10)
                    .zIndex(-1)
                    .annotation(
                        position: .top, spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled
                        )
                    ) {
                        ChartPopoverView()
                    }
                }
            }
            .accessibilityValue("\(2400) to \(3200) PPM")
            .accessibilityHidden(isOverview)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: Calendar.Component.month)) { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
            }
        }
        .if (!isOverview) { view in
            view.chartXSelection(value: $rawSelectedDate)
        }
        //.accessibilityChartDescriptor(self)
        .if (min != nil && max != nil) { view in
            view.chartYScale(domain: min!...max!)
        }
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Average Level")
            Text("\(2400)-\(3200) ")
                .font(.system(.title, design: .rounded))
                .foregroundColor(.primary)
            + Text("PPM")
        }
        .fontWeight(.semibold)
        .opacity(selectedDateValue == nil ? 1 : 0)
    }
    
    @ViewBuilder
    func ChartPopoverView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Salt Level")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4) {
                Text("\(Int(selectedDateValue!.salt))")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("PPM")
                    .font(.title3)
                    .textScale(.secondary)
                
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 10))
    }
}

struct SaltLevelRangeChart_Previews: PreviewProvider {
    static var previews: some View {
        SaltLevelRangeChart(isOverview: true)
        SaltLevelRangeChart(isOverview: false)
    }
}
