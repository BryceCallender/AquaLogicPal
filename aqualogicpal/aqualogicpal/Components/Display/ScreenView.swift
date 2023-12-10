import SwiftUI

struct ScreenView: View {
    @StateObject var client = AquaLogicClient.shared
    
    let waitingScreen: [[DisplaySection]] = [
        [
            .init(content: "Connecting...", blinking: false),
        ],
    ]

    
    var body: some View {
        ZStack {
            Image(systemName: "rectangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.cardBackground)
            
            Image(systemName: "rectangle")
                .resizable()
                .aspectRatio(contentMode: .fit)

            VStack {
                ForEach(client.aquaLogic?.display?.displaySections ?? waitingScreen, id: \.self) { sections in
                    HStack(spacing: 4) {
                        ForEach(Array(sections.enumerated()), id: \.offset) { index, display in
                            if (display.blinking) {
                                Text(display.content)
                                    .font(.system(size: 42))
                                    .blinking()
                            }
                            else {
                                Text(display.content)
                                    .font(.system(size: 42))
                            }
                        }
                    }
                }
            }
            .animation(.easeIn, value: client.aquaLogic?.display?.displaySections ?? waitingScreen)
        }
        .padding()
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
        
        ScreenView()
            .preferredColorScheme(.dark)
    }
}
