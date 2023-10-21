import SwiftUI

struct CheckBoxView: View {
    @Binding var cleaningRecord: CleaningRecord
    
    var body: some View {
        VStack {
            Checkbox(title: "Brushed", isOn: $cleaningRecord.brushed)
            Checkbox(title: "Skimmed", isOn: $cleaningRecord.skimmed)
            Checkbox(title: "Acid", isOn: $cleaningRecord.addedAcid)
            Checkbox(title: "Chlorine", isOn: $cleaningRecord.addedChlorine)
            Checkbox(title: "Tiles", isOn: $cleaningRecord.brushedTiles)
            Checkbox(title: "Skimmer Pot", isOn: $cleaningRecord.skimmerPot)
        }
        .padding()
    }
}

#Preview {
    CheckBoxView(cleaningRecord: Binding<CleaningRecord>.constant(CleaningRecord()))
}
