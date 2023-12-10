import SwiftUI

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval
    @Binding var cleaningRecord: CleaningRecord?
    @Binding var showSheet: Bool
    
    @Environment(AquaLogicPalStore.self) private var store
    
    func makeUIView(context: Context) -> some UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.availableDateRange = interval
        calendarView.calendar = Calendar(identifier: .gregorian)
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = dateSelection
        
        // Make sure our calendar calendarView adapts nicely to size constraints.
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let addedReport = store.changedCleaningRecord {
            uiView.reloadDecorations(forDateComponents: [addedReport.timestamp!.dateComponents], animated: true)
            store.changedCleaningRecord = nil
        }
        
        let reports = store.cleaningRecords.map { $0.timestamp!.dateComponents }
        if !reports.isEmpty {
            let currentMonthReports = reports.filter { $0.month! == Date.now.month }
            uiView.reloadDecorations(forDateComponents: currentMonthReports, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, store: store, cleaningRecord: $cleaningRecord, showSheet: $showSheet)
    }
}

class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    var parent: CalendarView
    var store: AquaLogicPalStore
    @Binding var cleaningRecord: CleaningRecord?
    @Binding var showSheet: Bool
    
    init(_ calendar: CalendarView, store: AquaLogicPalStore,  cleaningRecord: Binding<CleaningRecord?>, showSheet: Binding<Bool>) {
        parent = calendar
        self.store = store
        self._cleaningRecord = cleaningRecord
        self._showSheet = showSheet
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor: DateComponents) -> UICalendarView.Decoration? {
        let foundReports = store.cleaningRecords.filter { record in
            Calendar.current.isDate(record.timestamp!, equalTo: Calendar.current.date(from: decorationFor)!, toGranularity: .day)
        }
        
        if foundReports.isEmpty {
            return nil
        }
        
        return .default(color: .dragoonBlue)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) {
        if let dateComponents {
            cleaningRecord = store.cleaningRecords.first(where: { record in
                return Calendar.current.isDate(record.timestamp!, equalTo: Calendar.current.date(from: dateComponents)!, toGranularity: .day)
            })
            
            if cleaningRecord != nil {
                showSheet.toggle()
            }
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}
