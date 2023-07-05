import SwiftUI

struct RemoteButton: View {
    var label: String
    
    var body: some View {
        Button(action: {}) {
            Text(label)
                .font(.title)
                .frame(width: 100, height: 50)
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
