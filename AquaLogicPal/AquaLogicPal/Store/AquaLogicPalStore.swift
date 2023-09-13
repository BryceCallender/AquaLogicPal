import Foundation
import SwiftUI

@Observable class AquaLogicPalStore {
    var inventory = [InventoryItem]()
    var cleaningRecords = [CleaningRecord]()
    
    var saltData: [SaltData]
    var spaData: [SpaData]
    var poolData: [PoolEvents]
    
    var mostUsedPoolEvent: String? {
        poolData.max()?.name
    }
    
    var mostUsedPoolEventPercentage: Double {
        if poolData.isEmpty {
            return 0.0
        }
        
        let total = poolData.reduce(0) { $0 + $1.total }
        let max = poolData.max()!.total
        
        return (Double(max) / Double(total)) * 100
    }
    
    init() {
        self.inventory = []
        self.cleaningRecords = []
        self.spaData = []
        self.saltData = []
        self.poolData = []
    }
    
    func getInventory() async {
        do {
            let inventoryQuery = supabase.database.from("Inventory").select()
            inventory = try await inventoryQuery.execute().value
        } catch {
            
        }
    }
    
    func getCleaningRecords() async {
        do {
            let cleaningQuery = supabase.database.from("Cleaning").select().order(column: "CleanedOn", ascending: false)
            cleaningRecords = try await cleaningQuery.execute().value
        } catch {
            
        }
    }
    
    func getSpaData() async {
        
    }
    
    func getSaltData() async {
        
    }
    
    func getPoolEvents() async {
        do {
            let query = supabase.database.rpc(fn: "get_pool_event_occurrences")
            poolData = try await query.execute().value
        } catch {
            
        }
    }
}
