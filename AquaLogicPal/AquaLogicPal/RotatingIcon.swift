import SwiftUI

struct RotatingIcon: View {
    @State private var isRotating = 0.0
    
    var imageName: String
    var duration: Double = 2.0
     
    var body: some View {
        ImageView(imageName: imageName)
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(.linear(duration: 1)
                    .speed(duration).repeatForever(autoreverses: false)) {
                    isRotating = 360.0
                }
            }
    }
}

struct RotatingIcon_Previews: PreviewProvider {
    static var previews: some View {
        RotatingIcon(imageName: "fanblades")
    }
}
