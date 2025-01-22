import Foundation

enum TokenState: Codable {
    // Can be minted
    case deployed
    // Fully minted
    case finished
}

struct TokenDeployInfo: Decodable, Hashable {

    let tick: String
    let maxSupply: Double
    let limit: Double
    let preMinted: Double
    let minted: Double
    let holdersTotal: Double
    let mintTotal: Double
    let logoPath: String
    let releaseTimeInterval: TimeInterval
    let holders: [HolderInfo]

    enum CodingKeys: String, CodingKey {
        case tick
        case max = "max"
        case lim = "lim"
        case pre = "pre"
        case dec
        case minted
        case state
        case mtsAdd
        case holderTotal
        case mintTotal
        case logo
        case holder
    }

    init(
        tick: String,
        maxSupply: Double,
        limit: Double,
        preMinted: Double,
        minted: Double,
        holdersTotal: Double,
        mintTotal: Double,
        logoPath: String,
        releaseTimeInterval: TimeInterval,
        holders: [HolderInfo] = []
    ) {
        self.tick = tick
        self.maxSupply = maxSupply
        self.limit = limit
        self.preMinted = preMinted
        self.minted = minted
        self.holdersTotal = holdersTotal
        self.mintTotal = mintTotal
        self.logoPath = logoPath
        self.releaseTimeInterval = releaseTimeInterval
        self.holders = holders
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        tick = try container.decode(String.self, forKey: .tick)
        let decimal: Int
        if let _decimal = try? container.decode(Int.self, forKey: .dec) {
            decimal = _decimal
        } else if let _decimalString = try? container.decode(String.self, forKey: .dec), let _decimal = Int(_decimalString) {
            decimal = _decimal
        } else {
            decimal = 8
        }

        func parseValue(_ key: CodingKeys) throws -> Double {
            if let doubleValue = try? container.decode(Double.self, forKey: key) {
                return doubleValue / pow(10.0, Double(decimal))
            } else if
                let stringValue = try? container.decode(String.self, forKey: key),
                let doubleValue = Double(stringValue)
            {
                return doubleValue / pow(10.0, Double(decimal))
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Invalid numeric value"
                )
            }
        }

        maxSupply = try parseValue(.max)
        limit = try parseValue(.lim)
        preMinted = try parseValue(.pre)
        minted = try parseValue(.minted)

        holdersTotal = try container.decode(Double.self, forKey: .holderTotal)
        mintTotal = try container.decode(Double.self, forKey: .mintTotal)

        let pathStringValue = (try? container.decode(String.self, forKey: .logo)) ?? ""
        if pathStringValue.hasSuffix(".jpg") || pathStringValue.hasSuffix(".png") {
            logoPath = Constants.baseUrl + String(pathStringValue.dropLast(4))
        } else {
            logoPath = pathStringValue
        }

        if let timeInterval = try? container.decode(Double.self, forKey: .mtsAdd) {
            releaseTimeInterval = timeInterval / 1000
        } else if
            let stringValue = try? container.decode(String.self, forKey: .mtsAdd),
            let timeInterval = Double(stringValue)
        {
            releaseTimeInterval = timeInterval / 1000
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .mtsAdd,
                in: container,
                debugDescription: "Invalid Time Interval Format"
            )
        }
        holders = (try? container.decode([HolderInfo].self, forKey: .holder)) ?? []
    }
}
