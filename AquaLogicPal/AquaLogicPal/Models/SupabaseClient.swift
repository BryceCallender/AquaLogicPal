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
        supabase = SupabaseClient(supabaseURL: URL(string: "https://gsbghbhgwcjindroxilf.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdzYmdoYmhnd2NqaW5kcm94aWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTE1NTM0NzcsImV4cCI6MjAwNzEyOTQ3N30.Qpup_AJhAEGsZjZcs4a-avamN-Ut5FdTXRCQzTcrEqM")
    }
}
