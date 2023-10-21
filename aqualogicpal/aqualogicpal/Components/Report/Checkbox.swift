import SwiftUI

struct Checkbox: View {
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isOn ? .dragoonBlue : .gray)
            
            Text(title)
                .font(.title)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .padding()
        .onTapGesture {
            isOn.toggle()
        }
    }
}

#Preview {
    Checkbox(title: "Skimmed", isOn: Binding.constant(false))
}
