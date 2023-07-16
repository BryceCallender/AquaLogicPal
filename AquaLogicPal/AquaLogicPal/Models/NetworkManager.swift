import Foundation
import Alamofire

class NetworkManager: ObservableObject {
    static let ip: String = "192.168.86.52"
    static let port: Int = 5002
    static let baseUrl: String = "https://\(ip):\(port)"

    // dashboard information
    static let dashboardEndpoint = "/api/dashboard"
    static let saltLevelEndpoint = "\(dashboardEndpoint)/salt-levels"
    static let spaEventsEndpoint = "\(dashboardEndpoint)/spa-events"

    // aqualogic specific endpoints
    static let aquaLogicApiGroup = "/api/aqualogic"
    static let statesEndpoint = "\(aquaLogicApiGroup)/states"
    static let sendKeyEndpoint = "\(aquaLogicApiGroup)/key"
    static let setStateEndpoint = "\(aquaLogicApiGroup)/setstate"
    
    private let session: Session = {
        let manager = ServerTrustManager(evaluators: [ "\(ip)": DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    func get<T: Decodable>(type: T.Type, route: String, completion: @escaping (_ data: T?) -> Void) async throws {
        let endpoint = "\(NetworkManager.baseUrl)\(route)"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        decoder.dateDecodingStrategy = .customISO8601
        
        session.request(endpoint).responseDecodable(of: T.self, decoder: decoder) { response in
            switch response.result {
                case .success(let value):
                    completion(value)

                case .failure:
                    completion(nil)
            }
        }
    }
}