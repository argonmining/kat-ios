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
//    let state: TokenState
    let holdersTotal: Double
    let mintTotal: Double
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
        maxSupply: Double,
        limit: Double,
        preMinted: Double,
        minted: Double,
//        state: TokenState,
        holdersTotal: Double,
        mintTotal: Double,
        logoPath: String,
        releaseTimeInterval: TimeInterval
    ) {
        self.tick = tick
        self.maxSupply = maxSupply
        self.limit = limit
        self.preMinted = preMinted
        self.minted = minted
//        self.state = state
        self.holdersTotal = holdersTotal
        self.mintTotal = mintTotal
        self.logoPath = logoPath
        self.releaseTimeInterval = releaseTimeInterval
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        tick = try container.decode(String.self, forKey: .tick)
        let decimal = try container.decode(Int.self, forKey: .dec)

        func parseValue(_ key: CodingKeys) throws -> Double {
            guard
                let stringValue = try? container.decode(String.self, forKey: key),
                let doubleValue = Double(stringValue)
            else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Invalid numeric value"
                )
            }
            return doubleValue / pow(10.0, Double(decimal))
        }

        maxSupply = try parseValue(.max)
        limit = try parseValue(.lim)
        preMinted = try parseValue(.pre)
        minted = try parseValue(.minted)

//        state = try container.decode(TokenState.self, forKey: .state)

        holdersTotal = try container.decode(Double.self, forKey: .holderTotal)
        mintTotal = try container.decode(Double.self, forKey: .mintTotal)

        let pathStringValue = (try? container.decode(String.self, forKey: .logo)) ?? ""
        if pathStringValue.hasSuffix(".jpg") || pathStringValue.hasSuffix(".png") {
            logoPath = Constants.baseUrl + String(pathStringValue.dropLast(4))
        } else {
            logoPath = pathStringValue
        }

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
        releaseTimeInterval = timeInterval / 1000
    }
}
