import Foundation

struct NFTCollectionInfo: Decodable {

    let deployer: String
    let royaltyTo: String
    let buri: String
    let max: Int
    let royaltyFee: Double
    let daaMintStart: Int
    let premint: Int
    let tick: String
    let mtsAdd: TimeInterval
    let minted: Int
    let state: String
    let mtsmod: TimeInterval

    enum CodingKeys: String, CodingKey {
        case deployer
        case royaltyTo
        case buri
        case max
        case royaltyFee
        case daaMintStart
        case premint
        case tick
        case mtsAdd
        case minted
        case state
        case mtsMod
    }

    init(
        deployer: String,
        royaltyTo: String,
        buri: String,
        max: Int,
        royaltyFee: Double,
        daaMintStart: Int,
        premint: Int,
        tick: String,
        mtsAdd: TimeInterval,
        minted: Int,
        state: String,
        mtsmod: TimeInterval
    ) {
        self.deployer = deployer
        self.royaltyTo = royaltyTo
        self.buri = buri
        self.max = max
        self.royaltyFee = royaltyFee
        self.daaMintStart = daaMintStart
        self.premint = premint
        self.tick = tick
        self.mtsAdd = mtsAdd
        self.minted = minted
        self.state = state
        self.mtsmod = mtsmod
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        deployer = try container.decode(String.self, forKey: .deployer)
        royaltyTo = try container.decode(String.self, forKey: .royaltyTo)
        buri = try container.decode(String.self, forKey: .buri)

        max = Int(try container.decode(String.self, forKey: .max)) ?? 0
        minted = Int(try container.decode(String.self, forKey: .minted)) ?? 0

        royaltyFee = Double(try container.decode(String.self, forKey: .royaltyFee)) ?? 0.0
        daaMintStart = Int(try container.decode(String.self, forKey: .daaMintStart)) ?? 0
        premint = Int(try container.decode(String.self, forKey: .premint)) ?? 0

        tick = try container.decode(String.self, forKey: .tick)
        state = try container.decode(String.self, forKey: .state)

        mtsAdd = (Double(try container.decode(String.self, forKey: .mtsAdd)) ?? 0.0) / 1000.0
        mtsmod = (Double(try container.decode(String.self, forKey: .mtsMod)) ?? 0.0) / 1000.0
    }
}
