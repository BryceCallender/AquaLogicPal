import SwiftUI
import Charts

struct SaltLevelChartView: View {
    @EnvironmentObject private var networkManager: NetworkManager
    @State private var showEmptyState = false
    @State private var data: [SaltData] = []
    
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
        VStack(alignment: .leading) {
            TitleView(title: "Salt Levels")
            
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
                        LineMark(
                            x: .value("Date", saltData.eventTime, unit: .month),
                            y: .value("Salt (PPM)", saltData.salt)
                        )
                        .accessibilityLabel("\(saltData.salt) PPM")
                        .foregroundStyle(lineGradient)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .alignsMarkStylesWithPlotArea()
                        
//                        AreaMark(
//                            x: .value("Shape Type", saltData.eventTime, unit: .month),
//                            y: .value("Total Count", saltData.salt)
//                        )
//                        //.interpolationMethod(.catmullRom)
//                        .accessibilityLabel("INSERT ACCESSIBILITY HERE")
//                        .accessibilityLabel("\(saltData.salt) PPM")
//                        .foregroundStyle(areaGradient)
//                        .alignsMarkStylesWithPlotArea()
                    }
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
                try await networkManager.get(type: [SaltData].self, route: NetworkManager.saltLevelEndpoint) { response in
                    if response != nil {
                        data = response!
                        showEmptyState = false
                        print(data)
                    }
                }
            } catch {
                showEmptyState = true
            }
        }
    }
}

struct SaltLevelChartView_Previews: PreviewProvider {
    static var previews: some View {
        SaltLevelChartView()
            .environmentObject(NetworkManager())
    }
}
