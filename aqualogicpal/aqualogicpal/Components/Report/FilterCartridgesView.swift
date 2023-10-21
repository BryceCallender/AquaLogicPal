import SwiftUI

struct FilterCartridgesView: View {
    @Environment(AquaLogicPalStore.self) private var store
    
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
            await store.loadFilterRecord()
        }
    }
    
    private var filterCapsuleHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Filter Catridges")
                    .font(.system(.title, design: .rounded))
                
                Spacer()
                
                AsyncButton {
                    await addFilterCleanedDate()
                } label: {
                    Image(systemName: "checkmark.gobackward")
                        .font(.title)
                }
                .buttonStyle(.plain)
            }
            
            HStack(spacing: 4) {
                Text("Last Cleaned:")
                
                if let filterRecord = store.filterRecord {
                    Text(filterRecord.cleanedOn, format: .dateTime.year().month())
                } else {
                    ProgressView()
                        .tint(.dragoonBlue)
                        .padding(.leading)
                        
                }
            }
            .frame(height: 10)
        }
    }
    
    func addFilterCleanedDate() async {
        await store.addFilterCleanedDate()
    }
}

#Preview {
    FilterCartridgesView()
        .environment(AquaLogicPalStore())
}
