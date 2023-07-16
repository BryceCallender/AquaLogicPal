import SwiftUI

struct ContentView: View {
    @StateObject var client = AquaLogicClient.shared
    @State private var tabSelection: Tab = .temperatures
    
    enum Tab {
        case temperatures, controls
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            TemperaturesView().tag(Tab.temperatures)
            PoolControlsView().tag(Tab.controls)
        }
        .onAppear {
            client.subscribe(channelName: "aqualogic")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
