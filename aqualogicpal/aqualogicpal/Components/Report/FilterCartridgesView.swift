import SwiftUI

struct FilterCartridgesView: View {
    @State private var filterRecord: FilterRecord? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            filterCapsuleHeader
            
            Spacer()
            
            HStack(alignment: .center) {
                ZStack {
                    Image(systemName: "capsule.portrait")
                        .offset(x: -30)
                    Image(systemName: "capsule.portrait")
                        .offset(x: 30)
                    Image(systemName: "capsule.portrait")
                        .offset(x: 0, y: 30)
                }
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 60))
            .padding()
        }
        .frame(height: 200)
        .padding()
        .task {
            await loadFilterRecord()
        }
        
    }
    
    func loadFilterRecord() async {
        do {
            let filterQuery = supabase.database.from("Filters").select().single()
            filterRecord = try await filterQuery.execute().value
        } catch {
            filterRecord = nil
            print("### Loading Filter Record Error: \(error)")
        }
    }
    
    private var filterCapsuleHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Filter Catridges")
                    .font(.system(.title, design: .rounded))
                
                Spacer()
                
                Button {
                    print("Edit button was tapped")
                } label: {
                    Image(systemName: "checkmark.circle")
                        .font(.title)
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                Text("Last Cleaned:")
                
                if let filterRecord = filterRecord {
                    Text(filterRecord.cleanedOn, format: .dateTime.year().month())
                } else {
                    ProgressView()
                }
            }
            .frame(height: 10)
        }
    }
}

#Preview {
    FilterCartridgesView()
}
