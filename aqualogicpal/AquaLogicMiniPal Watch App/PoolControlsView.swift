import SwiftUI

struct PoolControlsView: View {
    @StateObject var client = AquaLogicClient.shared
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Controls")
                LazyVGrid(columns: columns, spacing: 8) {
                    PoolCardView(poolCard: PoolCard(label: "Pool", imageName: "figure.pool.swim", state: .pool, isEnabled: client.hasPoolState(state: .pool)))
        
                    CustomPoolCardView(poolCard: PoolCard(label: "Spa", imageName: "hot_tub", state: .spa, isEnabled: client.hasPoolState(state: .spa)))
        
                    PoolCardView(poolCard: PoolCard(label: "Filter", imageName: "fanblades", state: .filter, isEnabled: client.hasPoolState(state: .filter)),
                                 animation: AnimationDetails(duration: client.hasFlashingState(state: .filter) ? 1.0 : 2.0))
        
                    PoolCardView(poolCard: PoolCard(label: "Lights", imageName: "sun.max", state: .lights, isEnabled: client.hasPoolState(state: .lights)))
        
                    CustomPoolCardView(poolCard: PoolCard(label: "Waterfall", imageName: "Waterfall", state: .aux2, isEnabled: client.hasPoolState(state: .aux2)))
        
                    PoolCardView(poolCard: PoolCard(label: "Heater", imageName: "flame", state: .heater1, isEnabled: client.hasPoolState(state: .heater1)))
                }
            }
        }
    }
}

#Preview {
    PoolControlsView()
}
