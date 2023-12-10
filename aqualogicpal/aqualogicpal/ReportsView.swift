import SwiftUI

struct ReportsView: View {
    @Environment(AquaLogicPalStore.self) private var store
    @State private var showAddReportSheet = false
    @State private var showSelectedReportSheet = false
    @State private var selectedCleaningRecord: CleaningRecord?
    
    var body: some View {
        List {
            Section {
                FilterCartridgesView()
            }
            
            Section(header: Text("Cleaning Records")) {
                CalendarView(
                    interval: DateInterval(start: .distantPast, end: .distantFuture),
                    cleaningRecord: $selectedCleaningRecord,
                    showSheet: $showSelectedReportSheet
                )
            }
        }
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .task {
            await loadCleaningRecords()
        }
        .toolbar {
            Button(action: {
                showAddReportSheet = true
            }, label: {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showAddReportSheet) {
            PoolCleaningCheckListView()
        }
        .sheet(isPresented: $showSelectedReportSheet) {
            CleaningDetailView(cleaningDetail: $selectedCleaningRecord)
                .presentationDetents([.large])
        }
    }
    
    
    
    func loadCleaningRecords() async {
        await store.getCleaningRecords()
    }
}

#Preview {
    ReportsView()
        .environment(AquaLogicPalStore())
}
