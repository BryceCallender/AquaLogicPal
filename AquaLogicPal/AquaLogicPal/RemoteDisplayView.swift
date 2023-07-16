import SwiftUI

struct RemoteDisplayView: View {
    var body: some View {
        VStack {
            ScreenView()
            
            Grid {
                GridRow {
                    Spacer()
                    RemoteButton(label: "+")
                    Spacer()
                }
                GridRow {
                    RemoteButton(label: "<")
                    RemoteButton(label: "Menu")
                    RemoteButton(label: ">")
                }
                GridRow {
                    Spacer()
                    RemoteButton(label: "-")
                    Spacer()
                }
            }
            .padding(.bottom)
        }
    }
    
    func nothing() -> Void {
        
    }
}

struct RemoteDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteDisplayView()
    }
}