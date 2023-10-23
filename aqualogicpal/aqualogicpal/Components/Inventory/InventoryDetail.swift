import SwiftUI
//import AlertToast

struct InventoryDetail: View {
    @Environment(\.editMode) private var editMode
    
    @State var item: InventoryItem
    
    @State private var newAmount: Double = 0
    @State private var error: Error?
    @State private var showToast = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.title)
            
            if item.amount != nil {
                if editMode?.wrappedValue.isEditing == true {
                    Stepper("\(String(item.amount!)) containers", value: $newAmount, in: 0...4, step: 0.25)
                        .font(.title3)
                        .onChange(of: newAmount) {
                            item.amount = newAmount
                        }
                } else {
                    Text("\(String(item.amount!)) containers")
                        .font(.title3)
                        .padding(.top, 4)
                }
            }
            
            switch item.itemType {
                case .liquid:
                    LiquidView(amount: item.amount!)
                    .padding(.top)
                default:
                    Text("")
            }
            
            VStack(spacing: 8) {
                if item.itemType != .liquid {
                    AsyncButton {
                        await markForReplacement()
                    } label: {
                        Text(item.needsReplacement ? "Mark Replaced" : "Needs Replacement")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .if(item.itemType == .liquid) { view in
            view.toolbar {
                EditButton()
            }
        }
        .onAppear {
            newAmount = item.amount ?? 0
        }
        .onChange(of: editMode!.wrappedValue) {
            let isEditing = editMode!.wrappedValue.isEditing
            if (!isEditing) {
                Task {
                    await updateAmount()
                }
            }
        }
//        .toast(isPresenting: $showToast) {
//            if error != nil {
//                AlertToast(displayMode: .hud, type: .error(.red), title: "Error!", subTitle: error?.localizedDescription)
//            } else {
//                AlertToast(displayMode: .hud, type: .complete(.green), title: "Saved!")
//            }
//        }
    }
    
    func updateAmount() async {
        do {
//            let updateQuery = supabase.database.from("Inventory")
            showToast = true
        } catch {
            
        }
    }
    
    func markForReplacement() async {
        showToast = true
    }
}

#Preview {
    InventoryDetail(item: InventoryItem(id: 1, name: "Muriatic Acid", amount: 2.25, needsReplacement: true, itemType: .physical))
}
