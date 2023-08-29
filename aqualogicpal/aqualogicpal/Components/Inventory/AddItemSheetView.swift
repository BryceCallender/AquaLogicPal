import SwiftUI

struct AddItemSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var amount: Double?
    @State private var selectedItemType: ItemType = .physical
    
    @State private var error: Error?
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Text("Add Item")
                    .font(.title.weight(.bold))
                
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2.weight(.semibold))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            
            Divider() 
            
            VStack(spacing: 16) {
                Picker("Item Type", selection: $selectedItemType) {
                    Text("Physical").tag(ItemType.physical)
                    Text("Liquid").tag(ItemType.liquid)
                }
                .pickerStyle(.segmented)
                
                TextField("Item Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Amount (optional)", value: $amount, formatter: numberFormatter)
                    .textFieldStyle(.roundedBorder)
                    .opacity(selectedItemType == .liquid ? 1 : 0)
                
                
                if let error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .frame(height: 120)
            .padding()
            
            AsyncButton {
                await uploadItem()
                dismiss()
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.dragoonBlue)
            .disabled(name.isEmpty)
            .padding()
        }
    }
    
    func uploadItem() async {
        do {
            let item = InventoryItem(id: nil, name: name, amount: amount, needsReplacement: false, itemType: selectedItemType)
            try await supabase.database.from("Inventory")
                .insert(values: item).execute()
        } catch {
            print("### Insert Inventory Item Error: \(error)")
            self.error = error
        }
    }
}

#Preview {
    AddItemSheetView()
}
