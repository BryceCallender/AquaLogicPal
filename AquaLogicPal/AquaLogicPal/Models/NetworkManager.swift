import Foundation
import Alamofire
import SwiftUI

@Observable class NetworkManager {
    static let domain: String = "aqualogicpal.com"
    static let port: Int = 5002
    static let baseUrl: String = "https://\(domain):\(port)"

    // aqualogic specific endpoints
    static let aquaLogicApiGroup = "/api/aqualogic"
    static let statesEndpoint = "\(aquaLogicApiGroup)/states"
    static let sendKeyEndpoint = "\(aquaLogicApiGroup)/key"
    static let setStateEndpoint = "\(aquaLogicApiGroup)/setstate"
    
    func get<T: Decodable>(type: T.Type, route: String, completion: @escaping (_ data: T?) -> Void) async throws {
        let endpoint = "\(NetworkManager.baseUrl)\(route)"
        print(endpoint)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        decoder.dateDecodingStrategy = .customISO8601
        
        AF.request(endpoint).responseDecodable(of: T.self, decoder: decoder) { response in
            print(response)
            switch response.result {
                case .success(let value):
                    completion(value)

                case .failure:
                    completion(nil)
            }
        }
    }
}
