import SwiftUI

struct StatusView: View {
    @StateObject var client = AquaLogicClient.shared
    
    var imageName: String {
        if let isOk = client.aquaLogic?.isOk {
            return isOk ? "checkmark.circle" : "exclamationmark.triangle"
        }
        
        return "questionmark"
    }
    
    var color: Color? {
        if let isOk = client.aquaLogic?.isOk {
            return isOk ? .green : .yellow
        }
        
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TitleView("Status")
            
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(color)
                    .font(.system(.largeTitle))
                
                Text(client.aquaLogic?.status ?? "Unknown")
                    .font(.system(.largeTitle))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    StatusView()
}
