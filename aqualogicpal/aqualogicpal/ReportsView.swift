import SwiftUI

struct ReportsView: View {
    @State private var cleaningRecords = [CleaningRecord]()
    @State private var showSheet = false
    
    var body: some View {
        List {
            Section {
                FilterCartridgesView()
            }
            
            Section(header: Text("Cleaning Records")) {
                ForEach(cleaningRecords) { record in
                    NavigationLink(destination: CleaningDetailView(cleaningDetail: record)) {
                        CleaningRow(cleaningDetail: record)
                    }
                }
            }
        }
        .task {
            await loadCleaningRecords()
        }
        .toolbar {
            Button(action: {
                showSheet = true
            }, label: {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showSheet) {
            PoolCleaningCheckListView()
        }
    }
    
    
    
    func loadCleaningRecords() async {
        do {
            let cleaningQuery = supabase.database.from("Cleaning").select().order(column: "CleanedOn", ascending: false)
            cleaningRecords = try await cleaningQuery.execute().value
        } catch {
            cleaningRecords = []
            print("### Loading Cleaning Records Error: \(error)")
        }
    }
}

#Preview {
    ReportsView()
}
