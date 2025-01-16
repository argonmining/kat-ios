import Foundation

struct ChartTradeItem: Decodable, Identifiable, Equatable {

    let id: UUID
    let timestamp: TimeInterval
    let value: Double

    enum CodingKeys: String, CodingKey {
        case timestamp
        case close
    }

    init(timestamp: TimeInterval, value: Double) {
        self.id = UUID()
        self.timestamp = timestamp
        self.value = value
    }

    init(from decoder: Decoder) throws {
        self.id = UUID()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let timestampString = try container.decode(String.self, forKey: .timestamp)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = dateFormatter.date(from: timestampString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .timestamp,
                in: container,
                debugDescription: "Invalid timestamp format"
            )
        }
        timestamp = date.timeIntervalSince1970

        let closeString = try container.decode(String.self, forKey: .close)
        guard let closeValue = Double(closeString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .close,
                in: container,
                debugDescription: "Invalid close value format"
            )
        }
        value = closeValue
    }
}
