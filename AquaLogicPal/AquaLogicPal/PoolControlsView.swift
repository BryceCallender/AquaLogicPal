import SwiftUI
import AlertToast

struct PoolControlsView: View {
    var body: some View {
        @Bindable var client = AquaLogicClient.shared
        
        ScrollView(showsIndicators: false) {
            VStack {
                TemperaturesView()
                PoolStatesView()
            }
        }
        .toast(isPresenting: $client.isConnecting) {
            AlertToast(type: .loading, title: "Connecting...")
        }
    }
}

#Preview {
    PoolControlsView()
        .environment(AquaLogicPalStore())
}
