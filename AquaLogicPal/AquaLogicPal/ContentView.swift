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
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                                Label("Account", systemImage: "person.crop.circle")
//                                    .foregroundStyle(.black)
                            })
                        }
                    }
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
