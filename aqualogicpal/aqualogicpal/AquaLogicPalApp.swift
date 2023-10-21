import SwiftUI
import Supabase

@main
struct AquaLogicPalApp: App {
    @State private var store = AquaLogicPalStore()
    @State private var auth = AuthController()
    @State private var networkManager = NetworkManager()

    @State var supabaseInitialized = false
    
    var body: some Scene {
        WindowGroup {
            if supabaseInitialized {
                ContentView()
                    .environment(auth)
                    .environment(networkManager)
                    .environment(store)
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
