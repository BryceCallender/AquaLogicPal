import SwiftUI

struct ServiceModalView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 4) {
                Image(systemName: "wrench.and.screwdriver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 200)
                
                Text("Service Mode Enabled")
                    .font(.largeTitle)
                
                Text("Controls will return when maintenance is completed")
                    .font(.caption)
            }
        }
    }
}

struct ServiceModalView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceModalView()
    }
}
