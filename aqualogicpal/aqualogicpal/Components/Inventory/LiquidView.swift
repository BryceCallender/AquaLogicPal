import SwiftUI

struct LiquidView: View {
    var amount: Double
    
    var fullContainers: Int {
        Int(floor(amount))
    }
    
    var leftOverProgress: Double {
        amount.truncatingRemainder(dividingBy: 1)
    }
    
    var body: some View {
        HStack {
            ForEach(0..<fullContainers, id: \.self) { index in
                AcidContainer(progress: 1.0)
            }
            
            if fullContainers == 0 || (fullContainers > 1 && leftOverProgress > 0) {
                AcidContainer(progress: leftOverProgress)
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    LiquidView(amount: 1.0)
}
