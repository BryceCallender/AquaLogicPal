import SwiftUI
import Charts

struct SpaUseChartView: View {
    @EnvironmentObject private var networkManager: NetworkManager
    @State private var showEmptyState = false
    @State private var data: [SpaData] = []
    
    let gradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .blue,
                .green,
            ]
        ),
        startPoint: .bottom,
        endPoint: .top
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(title: "Spa Use")
            Chart {
                if showEmptyState {
                    RuleMark(y: .value("No Data", 0))
                        .foregroundStyle(gradient)
                        .annotation(content: {
                            Text("No spa information found.")
                                .font(.footnote)
                                .padding(10)
                        })
                } else {
                    ForEach(data) { spaData in
                        BarMark(
                            x: .value("Shape Type", spaData.eventTime, unit: .month),
                            y: .value("Total Count", spaData.count)
                        )
                    }
                    .foregroundStyle(gradient)
                    .alignsMarkStylesWithPlotArea()
                }
            }
            .chartXAxis {
                AxisMarks(values: data.map { $0.eventTime }) {
                    AxisValueLabel(format: .dateTime.month(), centered: true)
                }
            }
        }
        .onAppear {
            showEmptyState = data.isEmpty
        }
        .padding()
        .frame(height: 300)
        .animation(.easeInOut, value: showEmptyState)
        .task {
            do {
                try await networkManager.get(type: [SpaData].self, route: NetworkManager.spaEventsEndpoint) { response in
                    if response != nil {
                        data = response!
                        showEmptyState = false
                    }
                }
            } catch {
                showEmptyState = true
            }
        }
    }
}

struct SpaUseChartView_Previews: PreviewProvider {
    static var previews: some View {
        SpaUseChartView()
            .environmentObject(NetworkManager())
    }
}
