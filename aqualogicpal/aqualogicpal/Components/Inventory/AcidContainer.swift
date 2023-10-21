import SwiftUI

struct AcidContainer: View {
    @State private var waveOffset = 0.0
    
    var progress: Double
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Image(systemName: "drop.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.gray.opacity(0.3))
            
                AcidWave(progress: progress, waveHeight: 0.015, offset: waveOffset)
                    .fill(.yellow)
                    .mask {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                    }
            }
            .frame(width: size.width, height: size.height, alignment: .center)
            .onAppear {
//                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
//                    self.waveOffset = size.width
//                }
            }
        }
    }
}

#Preview {
    AcidContainer(progress: 1.0)
}

struct AcidWave: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var offset: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.height, by: 2) {
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
