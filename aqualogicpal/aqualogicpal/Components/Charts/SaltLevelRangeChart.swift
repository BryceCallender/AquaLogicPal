//https://github.com/jordibruin/Swift-Charts-Examples

import SwiftUI
import Charts

struct SaltLevelRangeChart: View {
    @Environment(AquaLogicPalStore.self) private var store
    @StateObject var client = AquaLogicClient.shared
    
    var isOverview: Bool
    
    @State private var rawSelectedDate: Date?
        
    @State private var barWidth = 10.0
    
    var selectedDateValue: (date: Date, minSalt: Double, maxSalt: Double)? {
        if rawSelectedDate == nil {
            return nil
        }
                
        if let saltData = store.saltRange.first(where: { $0.eventTime.month == rawSelectedDate!.month }) {
            var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: saltData.eventTime)
            
            newComponents.day = 15
            let newDate = Calendar.current.date(from: newComponents) ?? Date.now
            
            return (newDate, saltData.minSalt, saltData.maxSalt)
        }
        
        return nil
    }
    
    @State private var selectedContentType: ContentType = .graph
    
    var body: some View {
       if isOverview {
           chart
       } else {
           VStack(alignment: .leading) {
               Picker("ContentType", selection: $selectedContentType) {
                   ForEach(ContentType.allCases) { type in
                       Text(type.rawValue.capitalized)
                   }
               }
               .pickerStyle(.segmented)
               .padding([.horizontal, .top])
               
               if selectedContentType == .graph {
                   VStack(alignment: .leading) {
                       header
                       chart
                       ChartDetailCard(title: "Recommended", value: "2700 - 3400 PPM")
                           .padding(.top)
                       ChartDetailCard(title: "Current Level", value: "\(client.aquaLogic?.saltLevel ?? 0)")
                       Spacer()
                   }
                   .padding()
               } else {
                   List {
                       Section(header: Text("Records")) {
                           ForEach(store.saltEvents) { item in
                               HStack {
                                   Text(item.eventTime, style: .date)
                                   Text(item.eventTime, style: .time)
                                   Spacer()
                                   Text("\(Int(item.salt)) PPM")
                               }
                           }
                       }
                   }
                   .overlay {
                       if store.saltEvents.isEmpty {
                           ContentUnavailableView {
                               Label("No Records", systemImage: "pencil.and.list.clipboard")
                           } description: {
                               Text("Salt Events will appear here as changes occur.")
                           }
                       }
                   }
               }
           }
           .navigationBarTitle("Salt Level Range", displayMode: .inline)
       }
   }
    
    private var chart: some View {
        Chart {
            if (store.saltRange.isEmpty) {
                RuleMark(y: .value("No salt records", 0))
                    .annotation {
                        Text("No salt records recorded during this period.")
                            .font(.footnote)
                            .padding(10)
                    }
            } else {
                ForEach(store.saltRange) { dataPoint in
                    BarMark(
                        x: .value("Month", dataPoint.eventTime, unit: .month),
                        yStart: .value("PPM Min", dataPoint.minSalt),
                        yEnd: .value("PPM Max", dataPoint.maxSalt),
                        width: .fixed(isOverview ? 8 : barWidth)
                    )
                    .clipShape(.capsule)
                    .foregroundStyle(.dragoonBlue.gradient)
                }
            }
            
            if let selectedDateValue {
                RuleMark(
                    x: .value("Selected", selectedDateValue.date, unit: .day)
                )
                .foregroundStyle(.gray.opacity(0.3))
                
                .offset(yStart: -10)
                .zIndex(-1)
                .annotation(
                    position: .top,
                    spacing: 0,
                    overflowResolution: .init(x: .fit, y: .disabled)) {
                    ChartPopoverView()
                }
            }
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
        .if (store.saltMin > 0 && store.saltMax > 0) { view in
            view.chartYScale(domain: [store.saltMin, store.saltMax + 1000])
        }
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
        .task {
            // uncomment for testing preview
            // await store.getSaltData()
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Average Level")
            
            HStack(alignment: .bottom) {
                Text("\(store.averageSaltLevel)")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("PPM")
                    .offset(y: -3)
            }
            
            HStack {
                Text(Formatter.dateFormatter.string(from: Date().startOfYear()))
                Text("-")
                Text(Formatter.dateFormatter.string(from: Date().endOfYear()))
            }
        }
        .fontWeight(.semibold)
        .opacity(selectedDateValue == nil ? 1 : 0)
    }
    
    @ViewBuilder
    func ChartPopoverView() -> some View {
        VStack(alignment: .leading) {
            Text("Salt Level")
                .font(.title3)
            
            HStack(spacing: 2) {
                Text("\(Int(selectedDateValue!.minSalt)) - \(Int(selectedDateValue!.maxSalt))")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("PPM")
                    .font(.title3)
                    .textScale(.secondary)
            }
            
            Text("\(selectedDateValue!.date.formatted(.dateTime.month().year()))")
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(.popoutBackground, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    SaltLevelRangeChart(isOverview: true)
        .environment(AquaLogicPalStore())
}

#Preview {
    SaltLevelRangeChart(isOverview: false)
        .environment(AquaLogicPalStore())
}

#Preview {
    SaltLevelRangeChart(isOverview: false)
        .preferredColorScheme(.dark)
        .environment(AquaLogicPalStore())
}
