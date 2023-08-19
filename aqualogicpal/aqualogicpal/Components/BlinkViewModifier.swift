import SwiftUI

struct BlinkViewModifier: ViewModifier {
    let shouldBlink: Bool
    let duration: Double
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever()) {
                    if shouldBlink {
                        blinking = true
                    }
                }
            }
    }
}

extension View {
    func blinking(shouldBlink: Bool = true, duration: Double = 1.0) -> some View {
        modifier(BlinkViewModifier(shouldBlink: shouldBlink, duration: duration))
    }
}
