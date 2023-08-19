import SwiftUI

struct CleaningDetailView: View {
    var cleaningDetail: CleaningRecord
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading) {            
            Text(cleaningDetail.timestamp.formatted(.dateTime.day().month().year()))
                .font(.title2.weight(.semibold))
            
            if cleaningDetail.chemicalImageUrl != nil {
                AsyncImage(url: URL(string: cleaningDetail.chemicalImageUrl!)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(maxHeight: 150)
                
                Divider()
            }
            
            Text("Actions")
                .font(.title2)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.cardBackground)
                        .shadow(radius: 10)
                    
                    HStack {
                        Text("Acid Added")
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "arrow.down")
                            Text("pH")
                        }
                        .foregroundStyle(.red)
                    }
                    .padding()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.cardBackground)
                        .shadow(radius: 10)
                    
                    HStack {
                        Text("Skimmed")
                    }
                    .padding()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.cardBackground)
                        .shadow(radius: 10)
                    
                    HStack {
                        Text("Brushed")
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Pool Cleaning Report")
    }
}

#Preview {
    CleaningDetailView(cleaningDetail: CleaningRecord(id: 1, timestamp: Date.now, addedChemicals: true, skimmed: true, brushed: true, skimmerPot: false, brushedTiles: false, chemicalImageUrl: "https://gsbghbhgwcjindroxilf.supabase.co/storage/v1/object/public/chemicals/jooly_ranchers_p8s.jpeg"))
}
