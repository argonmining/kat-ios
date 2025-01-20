import Foundation

struct AddressTokenInfo: Decodable, Hashable {

    let ticker: String
    let balance: Double
    let locked: Double

    init (ticker: String, balance: Double, locked: Double) {
        self.ticker = ticker
        self.balance = balance
        self.locked = locked
    }

    enum CodingKeys: String, CodingKey {
        case ticker = "tick"
        case balance
        case locked
        case dec
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ticker = try container.decode(String.self, forKey: .ticker)
        let decimal: Int
        if let _decimal = try? container.decode(Int.self, forKey: .dec) {
            decimal = _decimal
        } else if let _decimalString = try? container.decode(String.self, forKey: .dec), let _decimal = Int(_decimalString) {
            decimal = _decimal
        } else {
            decimal = 8
        }

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

        balance = try parseValue(.balance)
        locked = try parseValue(.locked)
    }
}
