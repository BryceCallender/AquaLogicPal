import SwiftUI
import Charts

struct SaltLevelChart: View {
    @State private var showEmptyState = false
    @State private var data: [SaltData] = []
    @State private var rawSelectedDate: Date?
    
    var selectedData: SaltData? {
        if rawSelectedDate == nil {
            return nil
        }
        
        if let saltData = data.first(where: { Calendar.current.isDate($0.eventTime, equalTo: rawSelectedDate!, toGranularity: .month) }) {
            return saltData
        }
        
        return nil
    }
    
    let lineGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .blue,
                .green,
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    let areaGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .blue.opacity(0.5),
                .green.opacity(0.2),
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        Chart {
            if showEmptyState {
                RuleMark(y: .value("No Data", 0))
                    .foregroundStyle(lineGradient)
                    .annotation(content: {
                        Text("No salt level information found.")
                            .font(.footnote)
                            .padding(10)
                    })
            } else {
                ForEach(data) { saltData in
                    //                        AreaMark(
                    //                            x: .value("Date", saltData.eventTime, unit: .month),
                    //                            y: .value("Salt (PPM)", saltData.salt)
                    //                        )
                    //                        .foregroundStyle(lineGradient.opacity(0.5))
                    //                        .alignsMarkStylesWithPlotArea()
                    //                        .accessibilityHidden(true)
                    
                    LineMark(
                        x: .value("Date", saltData.eventTime, unit: .month),
                        y: .value("Salt (PPM)", saltData.salt)
                    )
                    .accessibilityLabel("\(saltData.salt) PPM")
                    .foregroundStyle(lineGradient)
                    .lineStyle(StrokeStyle(lineWidth: 4))
                    .alignsMarkStylesWithPlotArea()
                }
                if let selectedData {
                    RuleMark(
                        x: .value("Selected", selectedData.eventTime, unit: .day)
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
                        if selectedData != nil {
                            ChartPopoverView()
                        }
                    }
                }
            }
        }
        .chartXSelection(value: $rawSelectedDate)
        .animation(.easeInOut, value: showEmptyState)
        .onAppear {
            showEmptyState = data.isEmpty
        }
    }
    
    @ViewBuilder
    func ChartPopoverView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Salt Level")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4) {
                Text("\(Int(selectedData!.salt))")
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

#Preview {
    SaltLevelChart()
}
