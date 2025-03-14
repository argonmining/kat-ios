import Foundation

struct PoolPayout: Decodable, Identifiable, Hashable {
    var id: UUID = UUID()
    let walletAddress: String
    let amount: Double
    let amountType: AmountType
    let timestamp: TimeInterval
    let transactionHash: String
    
    enum AmountType: String, Decodable {
        case nacho, kas
    }
    
    init(walletAddress: String, amount: Double, amountType: AmountType, timestamp: TimeInterval, transactionHash: String) {
        self.id = UUID()
        self.walletAddress = walletAddress
        self.amount = amount
        self.amountType = amountType
        self.timestamp = timestamp
        self.transactionHash = transactionHash
    }
    
    private enum CodingKeys: String, CodingKey {
        case walletAddress, nachoAmount, kasAmount, timestamp, transactionHash, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.walletAddress = try container.decode(String.self, forKey: .walletAddress)
        self.timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        self.transactionHash = try container.decode(String.self, forKey: .transactionHash)
        self.amountType = try container.decode(AmountType.self, forKey: .type)
        
        switch self.amountType {
        case .nacho:
            let amountString = try container.decode(String.self, forKey: .nachoAmount)
            self.amount = Double(amountString) ?? 0.0
        case .kas:
            let amountString = try container.decode(String.self, forKey: .kasAmount)
            self.amount = Double(amountString) ?? 0.0
        }
    }
}
