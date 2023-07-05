import SwiftUI

struct StatusView: View {
    @StateObject var client = AquaLogicClient.shared
    @State private var shouldBlink: Bool = false
    
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
        HStack {
            Image(systemName: imageName)
                .foregroundColor(color)
                .font(.system(.largeTitle))
            
            Text(client.aquaLogic?.status ?? "Unknown Status")
                .font(.system(.largeTitle))
                .blinking(shouldBlink: shouldBlink)
        }
        .onChange(of: client.aquaLogic, perform: { newValue in
            if newValue == nil || shouldBlink {
                return
            }
            
            shouldBlink = !(newValue!.isOk)
        })
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
