import SwiftUI

struct PoolCardView: View {
    var poolCard: PoolCard
    var animation: AnimationDetails?
    
    @State private var isRotating = 0.0
    var duration: Double = 2.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(poolCard.isEnabled ? Color.dragoonBlue : Color.cardBackground)
                .shadow(radius: 10)
            
            VStack {
                if poolCard.isEnabled && animation != nil {
                    Image(systemName: poolCard.imageName)
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(duration).repeatForever(autoreverses: false)) {
                                isRotating = 360.0
                            }
                        }
                } else {
                    Image(systemName: poolCard.imageName)
                }
                
                Text(poolCard.label)
                    .font(.system(size: 10))
            }
            .padding()
        }
    }
}

struct PoolCardView_Previews: PreviewProvider {
    static var previews: some View {
        PoolCardView(poolCard: PoolCard(label: "Pool", imageName: "fanblades", state: .pool, isEnabled: true), animation: AnimationDetails(duration: 1.0))
    }
}
