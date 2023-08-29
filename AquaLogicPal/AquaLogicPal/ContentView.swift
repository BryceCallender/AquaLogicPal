import SwiftUI
import GoTrue

struct ContentView: View {
    @State var authEvent: AuthChangeEvent?
    @EnvironmentObject var auth: AuthController
    
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
            .environmentObject(AuthController())
            .environmentObject(NetworkManager())
        
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthController())
            .environmentObject(NetworkManager())
    }
}
