import SwiftUI

struct CleaningDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var cleaningDetail: CleaningRecord?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        if let cleaningDetail {
            VStack {
                HStack {
                    Text(cleaningDetail.timestamp!.formatted(.dateTime.day().month().year()))
                        .font(.title.weight(.bold))
                    
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title2.weight(.semibold))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        if cleaningDetail.chemicalImageUrl != nil {
                            AsyncImage(url: URL(string: cleaningDetail.chemicalImageUrl!)) { image in
                                image.resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(height: 300)
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
                        .padding([.leading, .trailing])
                        
                        Spacer()
                    }
                }
                .padding()
            }
        } else {
            Text("Empty")
        }
    }
}

#Preview {
    CleaningDetailView(cleaningDetail: .constant(CleaningRecord(id: 1, timestamp: Date.now, addedAcid: true, addedChlorine: false, skimmed: true, brushed: true, skimmerPot: false, brushedTiles: false, chemicalImageUrl: "https://gsbghbhgwcjindroxilf.supabase.co/storage/v1/object/public/chemicals/8:19:2023.jpg")))
}
