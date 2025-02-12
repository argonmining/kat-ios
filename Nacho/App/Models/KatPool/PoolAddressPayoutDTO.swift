import Foundation

struct PoolAddressPayoutDTO: Decodable, Identifiable, Hashable {
    var id: Double
    let walletAddress: String
    let amount: Double
    let timestamp: TimeInterval
    let transactionHash: String

    init(
        id: Double,
        walletAddress: String,
        amount: Double,
        timestamp: TimeInterval,
        transactionHash: String
    ) {
        self.id = id
        self.walletAddress = walletAddress
        self.amount = amount
        self.timestamp = timestamp
        self.transactionHash = transactionHash
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case walletAddress
        case amount
        case timestamp
        case transactionHash
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Double.self, forKey: .id)
        self.walletAddress = try container.decode(String.self, forKey: .walletAddress)

        let amountString = try container.decode(String.self, forKey: .amount)
        guard let amountValue = Double(amountString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .amount,
                in: container,
                debugDescription: "Amount string could not be converted to Double."
            )
        }
        self.amount = amountValue / pow(10, 8)

        self.timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        self.transactionHash = try container.decode(String.self, forKey: .transactionHash)
    }
}
