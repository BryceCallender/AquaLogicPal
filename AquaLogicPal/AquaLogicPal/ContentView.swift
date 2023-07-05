import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject var client = AquaLogicClient.shared
    @State private var isPresented = false
    
    var badgeValue: String? {
        if !(client.aquaLogic?.isOk ?? true) {
            return "!"
        }
        
        return nil
    }
    
    var body: some View {
        TabView {
            PoolControlsView()
                .tabItem {
                    Image(systemName: "av.remote")
                    Text("Controls")
                }
            
            RemoteDisplayView()
                .tabItem {
                    Image(systemName: "display")
                    Text("Remote Display")
                }
            
            DiagnosticsView()
                .badge(badgeValue)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Diagnostics")
                }
        }
        .onChange(of: client.aquaLogic, perform: { newValue in
            isPresented = client.aquaLogic.inServiceMode
        })
        .fullScreenCover(isPresented: $isPresented, content: ServiceModalView.init)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .preferredColorScheme(.dark)
    }
}
