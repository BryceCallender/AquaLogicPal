import SwiftUI
import GoTrue

struct ContentView: View {
    @Environment(AuthController.self) private var auth
    
    @State var authEvent: AuthChangeEvent?
    
    
    var body: some View {
        Group {
            if authEvent == .signedOut {
                LoginView()
            } else {
                HomeView()
            }
        }
        .task {
            for await event in supabase.auth.authEventChange {
                withAnimation {
                    authEvent = event
                }
                
                auth.session = try? await supabase.auth.session
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(AuthController())
            .environment(NetworkManager())
            .environment(AquaLogicPalStore())
        
        ContentView()
            .preferredColorScheme(.dark)
            .environment(AuthController())
            .environment(NetworkManager())
            .environment(AquaLogicPalStore())
    }
}
