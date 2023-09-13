import SwiftUI
import Charts

struct DiagnosticsView: View {
    @Environment(AquaLogicPalStore.self) private var store
    
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
                NavigationLink(destination: SaltLevelRangeChart(isOverview: false)) {
                    VStack(alignment: .leading) {
                        Text("Over the last year the salt levels averaged around 2400 PPM.")
                        
                        SaltLevelRangeChart(isOverview: true)
                    }
                }
            }

            Section {
                NavigationLink(destination:  SpaUseChart(isOverview: false)) {
                    VStack(alignment: .leading) {
                        Text("Over the last year you used the spa an average of 7 times.")
                        
                        SpaUseChart(isOverview: true)
                    }
                }                
            }
            
            Section {
                NavigationLink(destination: PoolEventUsageChart(isOverview: false)) {
                    HStack {
                        Text("Most popular event type is \(store.mostUsedPoolEvent ?? "") with \(store.mostUsedPoolEventPercentage, specifier: "%.0f")% of all events")
                        
                        PoolEventUsageChart(isOverview: true)
                    }
                }
            }
        }
    }
}

#Preview {
    DiagnosticsView()
        .environment(AquaLogicPalStore())
}
