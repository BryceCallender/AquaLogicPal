import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @State private var showPhotoPicker = false
    
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var previewImage: UIImage? = nil
    
    @Binding var imageData: Data?
    
    @State private var loading: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            VStack(spacing: 8) {
                if loading {
                    ProgressView()
                        .tint(.dragoonBlue)
                        .scaleEffect(2.0)
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .font(.largeTitle)
                        .imageScale(.large)
                        .foregroundStyle(.dragoonBlue)
                    
                    Text("Upload Chemical photo")
                        .font(.callout)
                }
            }
            .frame(width: size.width, height: size.height, alignment: .center)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .contentShape(.rect)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.dragoonBlue.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(.dragoonBlue, style: StrokeStyle(lineWidth: 1, dash: [12]))
                    
                }
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem)
            .onTapGesture {
                showPhotoPicker = true
            }
            .onChange(of: photoItem) {
                Task {
                    loading = true
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            imageData = uiImage.jpegData(compressionQuality: 0.1)
                            previewImage = uiImage
                            loading = false
                            return
                        }
                    }

                    print("Failed")
                }
            }
        }
    }
    
    func generateThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            
            await MainActor.run {
                previewImage = thumbnailImage
            }
        }
    }
}

#Preview {
    ImagePicker(imageData: Binding.constant(Data()))
}
