import SwiftUI

struct CustomPoolCardView: View {
    var poolCard: PoolCard
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(poolCard.isEnabled ? Color.dragoonBlue : Color.cardBackground)
                .shadow(radius: 10)
            
            VStack {
                Image(poolCard.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                TitleView(title: poolCard.label)
                    .padding(.top, 2)
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct CustomPoolCardView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPoolCardView(poolCard: PoolCard(label: "Spa", imageName: "hot_tub", state: .spa, isEnabled: false))
    }
}
