import SwiftUI

struct CleaningDetailView: View {
    var cleaningDetail: CleaningRecord
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(cleaningDetail.timestamp!.formatted(.dateTime.day().month().year()))
                    .font(.title2.weight(.semibold))
                
                if cleaningDetail.chemicalImageUrl != nil {
                    AsyncImage(url: URL(string: cleaningDetail.chemicalImageUrl!)) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 300)
                    
                    Divider()
                }
                
                Text("Actions")
                    .font(.title2)
                
                LazyVGrid(columns: columns, spacing: 8) {
                    if cleaningDetail.addedAcid {
                        Card {
                            HStack {
                                Text("Acid")
                                
                                HStack {
                                    Text("pH")
                                    Image(systemName: "arrow.down")
                                }
                                .foregroundStyle(.red)
                            }
                            .padding()
                        }
                    }
                    
                    if cleaningDetail.addedChlorine {
                        Card {
                            HStack {
                                Text("Chlorine Levels")
                                
                                
                                Image(systemName: "arrow.up")
                                    .foregroundStyle(.blue)
                            }
                            .padding()
                        }
                    }
                    
                    if cleaningDetail.skimmed {
                        Card {
                            HStack {
                                Text("Skimmed")
                            }
                            .padding()
                        }
                    }
                    
                    if cleaningDetail.brushed {
                        Card {
                            HStack {
                                Text("Brushed")
                            }
                            .padding()
                        }
                    }
                    
                    if cleaningDetail.brushedTiles {
                        Card {
                            HStack {
                                Text("Tiles")
                            }
                            .padding()
                        }
                    }
                    
                    if cleaningDetail.skimmerPot {
                        Card {
                            HStack {
                                Text("Emptied Pot")
                            }
                            .padding()
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Pool Cleaning Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CleaningDetailView(cleaningDetail: CleaningRecord(id: 1, timestamp: Date.now, addedAcid: true, addedChlorine: false, skimmed: true, brushed: true, skimmerPot: false, brushedTiles: false, chemicalImageUrl: "https://gsbghbhgwcjindroxilf.supabase.co/storage/v1/object/public/chemicals/8:19:2023.jpg"))
}
