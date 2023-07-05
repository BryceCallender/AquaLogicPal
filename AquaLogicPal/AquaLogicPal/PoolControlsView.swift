import SwiftUI

struct PoolControlsView: View {
    @StateObject var client = AquaLogicClient.shared
    
    var body: some View {
        VStack {
            TitleView(title: "Temperatures")
            
            HStack{
                TemperatureCardView(label: "Air", temperature: client.aquaLogic?.airTemp, isMetric: true)
                TemperatureCardView(label: "Pool", temperature: client.aquaLogic?.poolTemp, isMetric: true)
                TemperatureCardView(label: "Spa", temperature: client.aquaLogic?.spaTemp, isMetric: true)
            }
            .padding()
            
            TitleView(title: "Controls")
            
            ScrollView(showsIndicators: false) {
                Grid {
                    GridRow {
                        PoolCardView(poolCard: PoolCard(label: "Pool", imageName: "figure.pool.swim", state: .pool, isEnabled: client.hasPoolState(state: .pool)))
                        CustomPoolCardView(poolCard: PoolCard(label: "Spa", imageName: "hot_tub", state: .spa, isEnabled: client.hasPoolState(state: .spa)))
                    }
                    GridRow {
                        PoolCardView(poolCard: PoolCard(label: "Filter", imageName: "fanblades", state: .filter, isEnabled: client.hasPoolState(state: .filter)),
                                     animation: AnimationDetails(duration: client.hasFlashingState(state: .filter) ? 1.0 : 2.0))
                        PoolCardView(poolCard: PoolCard(label: "Lights", imageName: "sun.max", state: .lights, isEnabled: client.hasPoolState(state: .lights)))
                    }
                    GridRow {
                        CustomPoolCardView(poolCard: PoolCard(label: "Waterfall", imageName: "Waterfall", state: .aux2, isEnabled: client.hasPoolState(state: .aux2)))
                        PoolCardView(poolCard: PoolCard(label: "Heater", imageName: "flame", state: .heater1, isEnabled: client.hasPoolState(state: .heater1)))
                    }
                }
                .padding()
            }
        }.onAppear {
            client.subscribe(channelName: "aqualogic")
        }
    }
}

struct PoolControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PoolControlsView()
    }
}
