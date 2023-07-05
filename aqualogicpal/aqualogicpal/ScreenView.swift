import SwiftUI

struct ScreenView: View {
    @StateObject var client = AquaLogicClient.shared
    
    let waitingScreen: [[DisplaySection]] = [
        [
            .init(content: "Connecting...", blinking: false),
        ],
    ]

    
    var body: some View {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
        .padding()
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
