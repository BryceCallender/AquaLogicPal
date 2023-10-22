import SwiftUI

struct HomeView: View {
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
            NavigationStack {
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
                Text("Display")
            }
            
//            NavigationStack {
//                InventoryView()
//                    .navigationTitle("Inventory")
//            }
//            .tabItem {
//                Image(systemName: "archivebox")
//                Text("Inventory")
//            }
            
            NavigationStack {
                ReportsView()
                    .navigationTitle("Cleaning Reports")
            }
            .tabItem {
                Image(systemName: "pencil.and.list.clipboard")
                Text("Reports")
            }
            
            NavigationStack {
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

#Preview {
    HomeView()
        .environment(AquaLogicPalStore())
}
