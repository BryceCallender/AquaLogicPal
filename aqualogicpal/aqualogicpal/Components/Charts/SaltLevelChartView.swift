import SwiftUI
import Charts

struct SaltLevelChartView: View {
    @StateObject var client = SupaClient.shared
    
    @State private var saltData: [SaltData] = []
    @State private var loading: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {            
            if loading {
                ProgressView()
                    .padding()
                    .tint(.dragoonBlue)
                    .scaleEffect(2.0)
            } else {
//                SaltLevelChart(data: saltData)
            }
        }
        .padding()
        .task {
            do {
                loading = true
                // code here
                let query = client.database.from("SaltLevels").select()
                saltData = try await query.execute().value
                loading = false
            } catch {
                print("### Loading Salt levels Error: \(error)")
                loading = false
            }
        }
    }
}

#Preview {
    SaltLevelChartView()
}
