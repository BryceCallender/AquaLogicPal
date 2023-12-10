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
                        Text("Over the last year the salt levels averaged around \(store.averageSaltLevel) PPM.")
                        
                        SaltLevelRangeChart(isOverview: true)
                    }
                }
            }

            Section {
                NavigationLink(destination:  SpaUseChart(isOverview: false)) {
                    VStack(alignment: .leading) {
                        Text("Over the last year you used the spa an average of \(store.averageSpaUses) times.")
                        
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
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .task {
            async let saltData = store.getSaltData()
            async let spaData = store.getSpaData()
            async let poolData = store.getPoolEvents()
            
            await [saltData, spaData, poolData]
        }
    }
}

#Preview {
    DiagnosticsView()
        .environment(AquaLogicPalStore())
}
