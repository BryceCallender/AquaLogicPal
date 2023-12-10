import Foundation
import SwiftUI
import ActivityKit

@Observable class AquaLogicPalStore {
    var inventory = [InventoryItem]()
    var cleaningRecords = [CleaningRecord]()
    
    var changedCleaningRecord: CleaningRecord?
    
    var saltEvents: [SaltData]
    var saltRange: [SaltRange]
    var saltMin: Double
    var saltMax: Double
    
    var spaEvents: [SpaEvent]
    var spaData: [SpaData]
    
    var poolData: [PoolEvents]
    var poolEvents: [PoolEvent]
    
    var filterRecord: FilterRecord?
    
    var startedSpaActivity: Bool = false
    var activity: Activity<SpaWidgetAttributes>? = nil
    var activityStartTime: Date?
    
    var averageSpaUses: Int
    var averageSaltLevel: Int
    
    var maxSpaTemp: Int?
    var averageSpaDuration: TimeInterval
    
    var loadedSaltData: Bool = false
    var loadedSpaData: Bool = false
    var loadedPoolEvents: Bool = false
    
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
        self.spaEvents = []
        self.saltRange = []
        self.saltEvents = []
        self.poolData = []
        self.poolEvents = []
        self.averageSpaUses = 0
        self.averageSaltLevel = 0
        self.saltMin = 0
        self.saltMax = 0
        self.averageSpaDuration = 0
    }
    
    func getInventory() async {
        do {
            let inventoryQuery = supabase.database.from(Tables.Inventory.rawValue).select()
            inventory = try await inventoryQuery.execute().value
        } catch {
            
        }
    }
    
    func getCleaningRecords() async {
        do {
            let cleaningQuery = supabase.database.from(Tables.Cleaning.rawValue).select().order(column: "CleanedOn", ascending: false)
            cleaningRecords = try await cleaningQuery.execute().value
        } catch {
            
        }
    }
    
    func getSpaData() async {
        do {
            if loadedSpaData {
                return
            }
            
            let allSpaEvents: [SpaEvent] = try await supabase.database
                .from(Tables.SpaEvents.rawValue)
                        .execute().value
            
            let yearData = Dictionary(grouping: allSpaEvents,
                                      by: ({$0.startTime.year}))
            
            let sections = Dictionary(grouping: yearData[Date.now.year] ?? [],
                                      by: ({$0.startTime.month}))
            
            for i in 1...12 {
                // Specify date components
                var dateComponents = DateComponents()
                dateComponents.year = Date.now.year
                dateComponents.month = i
                dateComponents.day = 1
                
                // Create date from components
                let userCalendar = Calendar(identifier: .gregorian)
                let eventTime = userCalendar.date(from: dateComponents)!
                
                spaData.append(SpaData(count: 0, eventTime: eventTime))
            }
            
            let sortedKeysAndValues = sections.sorted(by: { $0.0 < $1.0 })
            
            var spaTimeIntervals: Double = 0.0
            for section in sortedKeysAndValues {
                let eventTime = section.value[0].startTime
                spaData[eventTime.month - 1] = SpaData(count: section.value.count, eventTime: eventTime)
                averageSpaUses += section.value.count
                spaTimeIntervals += section.value.reduce(0) { $0 + abs($1.startTime.timeIntervalSince($1.endTime)) }
                spaTimeIntervals /= Double(section.value.count)
                
                let sectionMaxTemp = section.value.max(by: { (a, b) in
                    a.maxTemp < b.maxTemp
                })!.maxTemp
                
                if sectionMaxTemp > (maxSpaTemp ?? 0) {
                    maxSpaTemp = sectionMaxTemp
                }
                
                spaEvents = section.value.sorted(by: { $0.endTime.compare($1.endTime) == .orderedDescending })  + spaEvents
            }
            
            if sortedKeysAndValues.count > 0 {
                averageSpaUses /= sortedKeysAndValues.count
                averageSpaDuration = (spaTimeIntervals / Double(sortedKeysAndValues.count))
            }
            
            loadedSpaData = true
        } catch {
            
        }
    }
    
    func getSaltData() async {
        do {
            if loadedSaltData {
                return
            }
            
            averageSaltLevel = 0
            
            let saltData: [SaltData] = try await supabase.database
                .from(Tables.SaltLevels.rawValue)
                        .execute().value
            
            let yearData = Dictionary(grouping: saltData,
                                      by: ({$0.eventTime.year}))
            
            let sections = Dictionary(grouping: yearData[Date.now.year] ?? [],
                                      by: ({$0.eventTime.month}))
            
            for i in 1...12 {
                // Specify date components
                var dateComponents = DateComponents()
                dateComponents.year = Date.now.year
                dateComponents.month = i
                dateComponents.day = 1
                
                // Create date from components
                let userCalendar = Calendar(identifier: .gregorian)
                let eventTime = userCalendar.date(from: dateComponents)!
                
                saltRange.append(SaltRange(eventTime: eventTime, minSalt: 0, maxSalt: 0))
            }
            
            let sortedKeysAndValues = sections.sorted(by: { $0.0 < $1.0 })
            
            for section in sortedKeysAndValues {
                let min = section.value.min()!
                let max = section.value.max()!
                
                let total = section.value.reduce(0) { $0 + $1.salt }
                averageSaltLevel += Int(total / (Double)(section.value.count))
                
                if min.salt < saltMin && min.salt > 0 {
                    saltMin = min.salt
                }
                
                if max.salt > saltMax && min.salt > 0 {
                    saltMax = max.salt
                }
                
                saltEvents = section.value.sorted(by: { $0.eventTime.compare($1.eventTime) == .orderedDescending }) + saltEvents
                saltRange[min.eventTime.month - 1] = SaltRange(eventTime: min.eventTime, minSalt: min.salt, maxSalt: max.salt)
            }
            
            if !sortedKeysAndValues.isEmpty {
                averageSaltLevel /= sortedKeysAndValues.count
            }
            
            loadedSaltData = true
        } catch {
            print("### Salt Data Error: \(error)")
        }
    }
    
    func getPoolEvents() async {
        do {
            if loadedPoolEvents {
                return
            }

            let poolEventData: [PoolEvent] = try await supabase.database
                .from(Tables.PoolEvents.rawValue)
                .select()
                .order(column: "EventTime", ascending: false)
                .execute().value
            
            let yearData = Dictionary(grouping: poolEventData,
                                      by: ({$0.eventTime.year}))
            
            let sections = Dictionary(grouping: yearData[Date.now.year] ?? [],
                                      by: ({$0.eventTime.month}))
            
            let sortedKeysAndValues = sections.sorted(by: { $0.0 < $1.0 })
            
            var poolDict: [PoolEventType: Int] = [
                PoolEventType.filter: 0,
                PoolEventType.heater: 0,
                PoolEventType.lights: 0,
                PoolEventType.waterfall: 0
            ]
            
            for section in sortedKeysAndValues {
                poolEvents = section.value + poolEvents
                section.value.forEach({ item in
                    poolDict[item.type]! += 1
                })
            }
            
            poolDict.forEach({ item in
                poolData.append(PoolEvents(name: String(describing: item.key), total: item.value))
            })
            
            poolData = poolData.sorted(by: { $0.total > $1.total })
            
            loadedPoolEvents = true
        } catch {
            print("### Pool Events Error: \(error)")
        }
    }
    
    func loadFilterRecord() async {
        do {
            let filterQuery = supabase.database.from(Tables.Filters.rawValue).select().order(column: "ID", ascending: false).limit(count: 1).single()
            filterRecord = try await filterQuery.execute().value
        } catch {
            filterRecord = nil
            print("### Loading Filter Record Error: \(error)")
        }
    }
    
    func addFilterCleanedDate() async {
        do {
            try await supabase.database.rpc(fn: "add_filter_cleaning").execute()
            filterRecord?.cleanedOn = Date.now
        } catch {
            print("### Insert Filter Cleaning Record Error: \(error)")
        }
    }
    
    func addCleaningRecord(cleaningRecord: CleaningRecord) async {
        do {
            try await supabase.database.from("Cleaning")
                .insert(values: cleaningRecord).execute()
            cleaningRecords.append(cleaningRecord)
            changedCleaningRecord = cleaningRecord
        } catch {
            print("### Insert Cleaning Record Error: \(error)")
        }
    }
    
    func startSpaActivity() {
        if startedSpaActivity {
            return
        }
        
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let spa = SpaWidgetAttributes(name: "Spa")
                activityStartTime = Date.now
                
                let initialState = SpaWidgetAttributes.SpaStatus(
                    temp: AquaLogicClient.shared.aquaLogic.spaTemp!,
                    startTime: activityStartTime!
                )
                
                activity = try Activity.request(
                    attributes: spa,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: .token
                )
                
                startedSpaActivity = true
            } catch {
                let errorMessage = """
                            Couldn't start activity
                            ------------------------
                            \(String(describing: error))
                            """
                
                print(errorMessage)
            }
        }
    }
    
    func updateActivity() async {
        guard let activity else {
            return
        }
        
        let state = SpaWidgetAttributes.SpaStatus(
            temp: AquaLogicClient.shared.aquaLogic.spaTemp!,
            startTime: activityStartTime!
        )
        
        await activity.update(
            ActivityContent<SpaWidgetAttributes.SpaStatus>(
                state: state,
                staleDate: Date.now + 15,
                relevanceScore: 50
            )
        )
    }
    
    func stopSpaActivity() {
        if !startedSpaActivity {
            return
        }
        
        let state = SpaWidgetAttributes.SpaStatus(
            temp: AquaLogicClient.shared.aquaLogic.spaTemp!,
            startTime: activityStartTime!
        )
        
        Task {
            await activity?.end(ActivityContent(state: state, staleDate: nil), dismissalPolicy: .immediate)
        }
    }
}
