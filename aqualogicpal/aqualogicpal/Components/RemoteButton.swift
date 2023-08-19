import SwiftUI

struct RemoteButton: View {
    var label: String
    
    var body: some View {
        Button(action: {}) {
            Text(label)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .cornerRadius(10)
        .buttonStyle(.borderedProminent)
    }
}

struct RemoteButton_Previews: PreviewProvider {
    static var previews: some View {
        RemoteButton(label: ">")
    }
}
