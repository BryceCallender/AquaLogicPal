import SwiftUI
import Charts

struct DiagnosticsView: View {
    @EnvironmentObject private var networkManager: NetworkManager
    
    var body: some View {
        List {
            Section {
                StatusView()
            }
                 
            Section {
                ChlorinationView()
                    .padding(.bottom, 30)
            }
                
            Section {
                NavigationLink("Over the last year the salt levels averaged around 2400 PPM.") {
                    SaltLevelRangeChart(isOverview: false)
                }
                
                SaltLevelRangeChart(isOverview: true)
            }

            Section {
                NavigationLink("Over the last year you used the spa an average of 7 times.") {
                    SpaUseChart(isOverview: false)
                }
                
                SpaUseChart(isOverview: true)
            }
            
            Section {
                NavigationLink(destination: PoolEventUsageChart(isOverview: false)) {
                    HStack {
                        Text("Most popular event type is X with % of all events")
                        
                        PoolEventUsageChart(isOverview: true)
                    }
                }
            }
        }
    }
}

#Preview {
    DiagnosticsView()
        .environmentObject(NetworkManager())
}
