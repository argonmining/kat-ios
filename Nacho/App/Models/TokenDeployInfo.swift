import Foundation

enum TokenState: Codable {
    // Can be minted
    case deployed
    // Fully minted
    case finished
}

struct TokenDeployInfo: Decodable {

    let tick: String
    let maxSupply: UInt64
    let limit: UInt64
    let preMinted: UInt64
    let minted: UInt64
    let state: TokenState
    let holdersTotal: UInt32
    let mintTotal: UInt64
    let logoPath: String
    let releaseTimeInterval: TimeInterval

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
    }

    init(
        tick: String,
        maxSupply: UInt64,
        limit: UInt64,
        preMinted: UInt64,
        minted: UInt64,
        state: TokenState,
        holdersTotal: UInt32,
        mintTotal: UInt64,
        logoPath: String,
        releaseTimeInterval: TimeInterval
    ) {
        self.tick = tick
        self.maxSupply = maxSupply
        self.limit = limit
        self.preMinted = preMinted
        self.minted = minted
        self.state = state
        self.holdersTotal = holdersTotal
        self.mintTotal = mintTotal
        self.logoPath = logoPath
        self.releaseTimeInterval = releaseTimeInterval
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tick = try container.decode(String.self, forKey: .tick)
        let decimal = try container.decode(Int.self, forKey: .dec)

        func parseValue(_ key: CodingKeys) throws -> UInt64 {
            guard
                let stringValue = try? container.decode(String.self, forKey: key),
                let bigValue = UInt64(stringValue)
            else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Invalid numeric value"
                )
            }
            return bigValue / UInt64(pow(10.0, Double(decimal)))
        }

        maxSupply = try parseValue(.max)
        limit = try parseValue(.lim)
        preMinted = try parseValue(.pre)
        minted = try parseValue(.minted)

        state = try container.decode(TokenState.self, forKey: .state)
        holdersTotal = try container.decode(UInt32.self, forKey: .holderTotal)
        mintTotal = try container.decode(UInt64.self, forKey: .mintTotal)
        logoPath = try container.decode(String.self, forKey: .logo)
        guard
            let stringValue = try? container.decode(String.self, forKey: .mtsAdd),
            let timeInterval = TimeInterval(stringValue)
        else {
            throw DecodingError.dataCorruptedError(
                forKey: .mtsAdd,
                in: container,
                debugDescription: "Invalid numeric value"
            )
        }
        releaseTimeInterval = timeInterval
    }
}
