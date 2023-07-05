import Foundation

struct PoolState: OptionSet {
    let rawValue: Int
    
    static let heater1          = PoolState(rawValue: 1 << 0)
    static let valve3           = PoolState(rawValue: 1 << 1)
    static let checkSystem      = PoolState(rawValue: 1 << 2)
    static let pool             = PoolState(rawValue: 1 << 3)
    static let spa              = PoolState(rawValue: 1 << 4)
    static let filter           = PoolState(rawValue: 1 << 5)
    static let lights           = PoolState(rawValue: 1 << 6)
    static let aux1             = PoolState(rawValue: 1 << 7)
    static let aux2             = PoolState(rawValue: 1 << 8)
    static let service          = PoolState(rawValue: 1 << 9)
    static let aux3             = PoolState(rawValue: 1 << 10)
    static let aux4             = PoolState(rawValue: 1 << 11)
    static let aux5             = PoolState(rawValue: 1 << 12)
    static let aux6             = PoolState(rawValue: 1 << 13)
    static let valve4           = PoolState(rawValue: 1 << 14)
    static let spillover        = PoolState(rawValue: 1 << 15)
    static let systemOff        = PoolState(rawValue: 1 << 16)
    static let aux7             = PoolState(rawValue: 1 << 17)
    static let aux8             = PoolState(rawValue: 1 << 18)
    static let aux9             = PoolState(rawValue: 1 << 19)
    static let aux10            = PoolState(rawValue: 1 << 20)
    static let aux11            = PoolState(rawValue: 1 << 21)
    static let aux12            = PoolState(rawValue: 1 << 22)
    static let aux13            = PoolState(rawValue: 1 << 23)
    static let aux14            = PoolState(rawValue: 1 << 24)
    static let superChlorinate  = PoolState(rawValue: 1 << 25)
    static let heaterAutoMode   = PoolState(rawValue: 1 << 30)
    static let filterLowSpeed   = PoolState(rawValue: 1 << 31)
}

extension PoolState: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var result: PoolState = []
        while !container.isAtEnd {
            let optionName = try container.decode(String.self)
            guard let selection = PoolState.mapping[optionName] else {
                let context = DecodingError.Context(
                  codingPath: decoder.codingPath,
                  debugDescription: "PoolState not recognized: \(optionName)")
                throw DecodingError.valueNotFound(String.self, context)
            }
            result.insert(selection)
        }
        self = result
    }

    private static let mapping: [String : PoolState] = [
        "HEATER_1" : .heater1,
        "VALVE_3" : .valve3,
        "CHECK_SYSTEM" : .checkSystem,
        "POOL" : .pool,
        "SPA" : .spa,
        "FILTER" : .filter,
        "LIGHTS" : .lights,
        "AUX_1" : .aux1,
        "AUX_2" : .aux2,
        "SERVICE" : .service,
        "AUX_3" : .aux3,
        "AUX_4" : .aux4,
        "AUX_5" : .aux5,
        "AUX_6" : .aux6,
        "VALVE_4" : .valve4,
        "SPILLOVER" : .spillover,
        "SYSTEM_OFF" : .systemOff,
        "AUX_7" : .aux7,
        "AUX_8" : .aux8,
        "AUX_9" : .aux9,
        "AUX_10" : .aux10,
        "AUX_11" : .aux11,
        "AUX_12" : .aux12,
        "AUX_13" : .aux13,
        "AUX_14" : .aux14,
        "SUPER_CHLORINATE" : .superChlorinate,
        "HEATER_AUTO_MODE" : .heaterAutoMode,
        "FILTER_LOW_SPEED" : .filterLowSpeed
    ]
}
