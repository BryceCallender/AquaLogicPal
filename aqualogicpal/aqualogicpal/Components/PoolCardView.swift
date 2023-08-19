import SwiftUI

struct PoolCardView: View {
    var poolCard: PoolCard
    var animation: AnimationDetails?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(poolCard.isEnabled ? .dragoonBlue : .cardBackground)
                .shadow(radius: 10)

            VStack {
                if poolCard.isEnabled && animation != nil {
                    RotatingIcon(
                        imageName: poolCard.imageName,
                        duration: animation!.duration)
                } else {
                    ImageView(imageName: poolCard.imageName)
                }
                
                TitleView(poolCard.label)
                    .padding(.top, 2)
            }
            .foregroundColor(poolCard.isEnabled ? .cardTextEnabled : .cardTextDisabled)
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct PoolCardView_Previews: PreviewProvider {
    static var previews: some View {
        PoolCardView(poolCard: PoolCard(label: "Pool", imageName: "figure.pool.swim", state: .pool, isEnabled: true))
    }
}
