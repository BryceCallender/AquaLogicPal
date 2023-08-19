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
            NavigationView {
                PoolControlsView()
                    .navigationTitle("Controls")
            }
            .tabItem {
                Image(systemName: "av.remote")
                Text("Controls")
            }
            
            RemoteDisplayView()
            .tabItem {
                Image(systemName: "display")
                Text("Remote Display")
            }
            
            NavigationStack {
                MaintenanceView()
                    .navigationTitle("Maintenance")
            }
            .tabItem {
                Image(systemName: "calendar.badge.checkmark")
                Text("Maintenance")
            }
            
            NavigationView {
                DiagnosticsView()
                    .navigationTitle("Diagnostics")
            }
            .badge(badgeValue)
            .tabItem {
                Image(systemName: "gearshape")
                Text("Diagnostics")
            }
        }
        .onChange(of: client.aquaLogic) { oldState, newState in
            isPresented = client.aquaLogic.inServiceMode
        }
        .fullScreenCover(isPresented: $isPresented, content: ServiceModalView.init)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NetworkManager())
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(NetworkManager())
    }
}
