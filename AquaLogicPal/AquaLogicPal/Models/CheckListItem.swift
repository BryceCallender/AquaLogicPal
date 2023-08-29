import Foundation

struct CheckListItem: Identifiable {
    var id = UUID()
    var title: String
    var isChecked: Bool = false
}
