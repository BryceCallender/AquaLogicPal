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
                authEvent = event                
                auth.session = try? await supabase.auth.session
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthController())
        .environment(NetworkManager())
        .environment(AquaLogicPalStore())
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .environment(AuthController())
        .environment(NetworkManager())
        .environment(AquaLogicPalStore())
}
