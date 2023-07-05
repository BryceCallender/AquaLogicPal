import Foundation

class AquaLogic: Decodable {
    let display: Display?
    let poolStates: PoolState?
    let flashingStates: PoolState?
    let isMetric: Bool?
    let airTemp: Int?
    let spaTemp: Int?
    let poolTemp: Int?
    let poolChlorinatorPercent: Double?
    let spaChlorinatorPercent: Double?
    let saltLevel: Double?
    let status: String?
    let isHeaterEnabled: Bool?
    let isSuperChlorinate: Bool?
    let waterfall: Bool?
    let pumpSpeed: Int?
    let pumpPower: Int?
    let multiSpeedPump: Bool?
    let heaterAutoMode: Bool?
    
    var isOk: Bool {
        if status != nil {
            return status!.contains("Ok")
        }
        
        return false
    }
    
    var inServiceMode: Bool {
        return hasPoolState(state: .service)
    }
    
    func hasPoolState(state: PoolState) -> Bool {
        return poolStates?.contains(state) ?? false
    }
    
    func hasFlashingState(state: PoolState) -> Bool {
        return flashingStates?.contains(state) ?? false
    }
}

extension AquaLogic: Equatable {
    static func == (lhs: AquaLogic, rhs: AquaLogic) -> Bool {
        return false
    }
}
