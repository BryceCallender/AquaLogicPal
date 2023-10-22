import Foundation
import Supabase

class SupaClient : NSObject, ObservableObject {
    static let shared = SupaClient()
    
    var supabase: SupabaseClient!
    
    var database: PostgrestClient {
        supabase.database
    }
    
    var auth: GoTrueClient {
        supabase.auth
    }
    
    override init() {
        supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    }
}
