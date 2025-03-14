import Foundation

struct PoolAddressPayoutDTO: Decodable, Identifiable, Hashable {
    var id: Double
    let walletAddress: String
    let amount: Double
    let amountType: AmountType
    let timestamp: TimeInterval
    let transactionHash: String
    
    enum AmountType: String, Decodable {
        case nacho, kas
    }
    
    init(
        id: Double,
        walletAddress: String,
        amount: Double,
        amountType: AmountType,
        timestamp: TimeInterval,
        transactionHash: String
    ) {
        self.id = id
        self.walletAddress = walletAddress
        self.amount = amount
        self.amountType = amountType
        self.timestamp = timestamp
        self.transactionHash = transactionHash
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, walletAddress, nachoAmount, kasAmount, timestamp, transactionHash, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Double.self, forKey: .id)
        self.walletAddress = try container.decode(String.self, forKey: .walletAddress)
        self.timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        self.transactionHash = try container.decode(String.self, forKey: .transactionHash)
        self.amountType = try container.decode(AmountType.self, forKey: .type)
        
        switch self.amountType {
        case .nacho:
            let amountString = try container.decode(String.self, forKey: .nachoAmount)
            guard let amountValue = Double(amountString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .nachoAmount,
                    in: container,
                    debugDescription: "Nacho amount string could not be converted to Double."
                )
            }
            self.amount = amountValue
        case .kas:
            let amountString = try container.decode(String.self, forKey: .kasAmount)
            guard let amountValue = Double(amountString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .kasAmount,
                    in: container,
                    debugDescription: "Kas amount string could not be converted to Double."
                )
            }
            self.amount = amountValue
        }
    }
}
