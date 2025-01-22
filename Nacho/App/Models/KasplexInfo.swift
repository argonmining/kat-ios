import Foundation

struct KasplexInfo: Decodable {

    let opTotal: Double
    let tokenTotal: Double
    let feeTotal: Double

    init(opTotal: Double, tokenTotal: Double, feeTotal: Double) {
        self.opTotal = opTotal
        self.tokenTotal = tokenTotal
        self.feeTotal = feeTotal
    }

    enum CodingKeys: String, CodingKey {
        case opTotal
        case tokenTotal
        case feeTotal
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        func parseValue(_ key: CodingKeys) throws -> Double {
            if let doubleValue = try? container.decode(Double.self, forKey: key) {
                return doubleValue
            } else if
                let stringValue = try? container.decode(String.self, forKey: key),
                let doubleValue = Double(stringValue)
            {
                return doubleValue
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Invalid numeric value"
                )
            }
        }
        self.opTotal = try parseValue(.opTotal)
        self.tokenTotal = try parseValue(.tokenTotal)
        self.feeTotal = try parseValue(.feeTotal) / pow(10.0, Double(8))
    }
}
