import SwiftUI

struct ChartDetailCard: View {
    @Environment(\.colorScheme) var colorScheme

    var title: String
    var value: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(colorScheme == .dark ? .black : .secondary.opacity(0.3))
            
            HStack {
                Text(title)
                Spacer()
                Text(value ?? "Unavailable")
                    .bold()
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: colorScheme == .dark ? 1 : 0)
        )
        .frame(height: 50)
    }
}

#Preview {
    ChartDetailCard(title: "Title", value: "Value")
}

#Preview {
    ChartDetailCard(title: "Title", value: "Value")
        .preferredColorScheme(.dark)
}
