import SwiftUI
import Charts

struct DiagnosticsView: View {
    @EnvironmentObject private var networkManager: NetworkManager
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                StatusView()
                    
                ChlorinationView()
                    .padding(.bottom, 20)
                
                    SaltLevelChartView()

                
                SpaUseChartView()
            }
            .padding()
        }
    }
}

#Preview {
    DiagnosticsView()
        .environmentObject(NetworkManager())
}
