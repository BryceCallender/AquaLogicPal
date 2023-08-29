import SwiftUI
import Supabase

@main
struct AquaLogicPalApp: App {
    @State var supabaseInitialized = false
    @StateObject var auth = AuthController()
    
    var body: some Scene {
        WindowGroup {
            if supabaseInitialized {
                ContentView()
                    .environmentObject(auth)
                    .environmentObject(NetworkManager())
            } else {
              ProgressView()
                .task {
                  await supabase.auth.initialize()
                  supabaseInitialized = true
                }
            }
        }
    }
}

let supabase = SupabaseClient(
  supabaseURL: Secrets.supabaseURL,
  supabaseKey: Secrets.supabaseAnonKey
)
