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
                    .frame(width: 20, height: 20)
                
                Text(poolCard.label)
                    .font(.system(size: 10))
            }
            .padding()
        }
    }
}

struct CustomPoolCardView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPoolCardView(poolCard: PoolCard(label: "Spa", imageName: "hot_tub", state: .spa, isEnabled: false))
    }
}
