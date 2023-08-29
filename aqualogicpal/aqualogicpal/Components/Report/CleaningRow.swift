import SwiftUI

struct CleaningRow: View {
    var cleaningDetail: CleaningRecord
    
    var body: some View {
        VStack {
            Text(cleaningDetail.timestamp!.formatted(.dateTime.day().month().year()))
                
        }
    }
}

#Preview {
    CleaningRow(cleaningDetail: CleaningRecord())
}
