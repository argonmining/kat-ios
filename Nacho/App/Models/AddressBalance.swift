import Foundation

struct AddressBalance: Decodable, Hashable {

    let address: String
    let balance: Double

    init (address: String, balance: Double) {
        self.address = address
        self.balance = balance
    }

    enum CodingKeys: String, CodingKey {
        case address
        case balance
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        let decimal: Int = 8
        func parseValue(_ key: CodingKeys) throws -> Double {
            guard
                let doubleValue = try? container.decode(Double.self, forKey: key)
            else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Invalid numeric value"
                )
            }
            return doubleValue / pow(10.0, Double(decimal))
        }
        balance = try parseValue(.balance)
    }
}
