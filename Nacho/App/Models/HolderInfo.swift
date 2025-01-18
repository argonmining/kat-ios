import Foundation

struct HolderInfo: Decodable, Hashable {

    let address: String
    let amount: Double

    enum CodingKeys: String, CodingKey {
        case address
        case amount
    }

    init(address: String, amount: Double) {
        self.address = address
        self.amount = amount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        if let _amount = try? container.decode(Double.self, forKey: .amount) {
            amount = _amount / pow(10.0, Double(8))
        } else if
            let stringValue = try? container.decode(String.self, forKey: .amount),
            let doubleValue = Double(stringValue)
        {
            amount = doubleValue / pow(10.0, Double(8))
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .amount,
                in: container,
                debugDescription: "Invalid numeric value"
            )
        }
    }
}
