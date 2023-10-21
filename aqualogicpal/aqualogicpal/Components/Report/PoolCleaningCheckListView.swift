import SwiftUI
import PhotosUI
import SupabaseStorage

struct PoolCleaningCheckListView: View {
    @Environment(AquaLogicPalStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var imageData: Data?
    @State private var error: Error?
    @State private var cleaningRecord: CleaningRecord = CleaningRecord()
    
    var body: some View {
        VStack {
            HStack {
                Text("Add Report")
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
                VStack {
                    ImagePicker(imageData: $imageData)
                        .frame(width: 350, height: 300)
                    
                    CheckBoxView(cleaningRecord: $cleaningRecord)
                    
                    if let error {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    AsyncButton {
                        await uploadReport()
                        dismiss()
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.dragoonBlue)
                    .padding()
                }
                .padding(.top)
            }
        }
    }
    
    func uploadReport() async {
        if let imageData {
            let formatter = DateFormatter()
            formatter.dateFormat = "M:d:y"
            
            let name = formatter.string(from: Date.now)

            let file = File(name: "\(name)",
                            data: imageData,
                            fileName: "\(name).jpg",
                            contentType: "image/jpeg")
            
            let path = "\(name).jpg"
            
            do {
                let uploadResponse = try await supabase.storage.from(id: "chemicals").upload(
                    path: path,
                    file: file,
                    fileOptions: FileOptions(cacheControl: "3600")
                )
                
            } catch {
                self.error = error
            }

            cleaningRecord.chemicalImageUrl = try? supabase.storage.from(id: "chemicals").getPublicURL(path: path).absoluteString
        }
        
        cleaningRecord.timestamp = Date.now
        await store.addCleaningRecord(cleaningRecord: cleaningRecord)
    }
}

#Preview {
    PoolCleaningCheckListView()
        .environment(AquaLogicPalStore())
}
