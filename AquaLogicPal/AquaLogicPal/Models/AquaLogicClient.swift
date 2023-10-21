import Foundation
import PusherSwift


@Observable class AquaLogicClient : NSObject, ObservableObject {
    static let shared = AquaLogicClient()
    
    var isConnecting: Bool
    var pusher: Pusher!
    var channel: PusherChannel!
    
    var aquaLogic: AquaLogic!
    var pusherService = AquaLogicPusherDelegate()
    
    override init() {
        isConnecting = false
        super.init()

        let options = PusherClientOptions(
          host: .cluster("us3")
        )
        
        isConnecting = true
        pusher = Pusher(key: Secrets.pusherKey, options: options)
        pusher.connect()
        pusher.connection.delegate = pusherService
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

class AquaLogicPusherDelegate: PusherDelegate {
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        AquaLogicClient.shared.isConnecting = false
    }

    func debugLog(message: String) {
        // ...
    }

    func subscribedToChannel(name: String) {
        // ...
    }

    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        // ...
    }

    func receivedError(error: PusherError) {
        // ...
    }

    func failedToDecryptEvent(eventName: String, channelName: String, data: String?) {
        // ...
    }

}
