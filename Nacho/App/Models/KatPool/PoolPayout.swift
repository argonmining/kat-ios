import Foundation

struct PoolPayout: Decodable, Identifiable, Hashable {
    var id: UUID = UUID() // Excluded from decoding, auto-generated
    let walletAddress: String
    let amount: Double
    let timestamp: TimeInterval
    let transactionHash: String

    init(walletAddress: String, amount: Double, timestamp: TimeInterval, transactionHash: String) {
        self.id = UUID()
        self.walletAddress = walletAddress
        self.amount = amount
        self.timestamp = timestamp
        self.transactionHash = transactionHash
    }

    private enum CodingKeys: String, CodingKey {
        case walletAddress, amount, timestamp, transactionHash
    }
}
