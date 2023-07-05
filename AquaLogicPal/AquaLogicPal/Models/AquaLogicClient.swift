import Foundation
import PusherSwift

class AquaLogicClient : NSObject, ObservableObject {
    static let shared = AquaLogicClient()
    
    var pusher: Pusher!
    var channel: PusherChannel!
    
    @Published var aquaLogic: AquaLogic!
    
    override init() {
        super.init()

        let options = PusherClientOptions(
          host: .cluster("us3")
        )
        
        pusher = Pusher(key: "5df799c903bc4dd50a6c", options: options)
        pusher.connect()
    }
    
    func subscribe(channelName: String) {
        channel = pusher.subscribe(channelName: channelName)
        
        bindDisplayEvent()
    }
    
    func unsubscribe(channelName: String) {
        pusher.unsubscribe(channelName)
    }
    
    func disconnect() {
        pusher.disconnect()
    }
    
    func bindDisplayEvent() {
        channel.bind(eventName: "update_display", eventCallback: { (event: PusherEvent) -> Void in
            if let json: String = event.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromPascalCase
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    self.aquaLogic = try decoder.decode(AquaLogic.self, from: json.data(using: .utf8)!)
                } catch {
                    print(error)
                }
            }
        })
    }
    
    func hasPoolState(state: PoolState) -> Bool {
        return aquaLogic?.hasPoolState(state: state) ?? false
    }
    
    func hasFlashingState(state: PoolState) -> Bool {
        return aquaLogic?.hasFlashingState(state: state) ?? false
    }
}
