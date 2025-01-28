import Foundation

struct PoolHistoryRsponse: Decodable {
    let result: [PoolHistoryValues]
}


struct PoolHistoryValue: Decodable {
    let id: UUID
    let timestamp: Double
    let hashRate: Double  // Keep hashRate as String, because the second value is always a string

    init(timestamp: Double, hashRate: Double) {
        self.id = UUID()
        self.timestamp = timestamp
        self.hashRate = hashRate
    }
    
    // Custom initializer to decode the array directly
    init(from decoder: Decoder) throws {
        self.id = UUID()
        var container = try decoder.unkeyedContainer()
        
        // Decode the first element as the timestamp (Double)
        self.timestamp = try container.decode(Double.self)
        
        // Decode the second element as the hash rate (String)
        let hashRate = try container.decode(String.self)
        self.hashRate = (Double(hashRate) ?? 0) / 1000
    }

    func toChartDataItem() -> LineChartDS.ChartData {
        return .init(id: id, timestamp: timestamp, value: hashRate)
    }
}

struct PoolHistoryValues: Decodable {
    let values: [PoolHistoryValue]  // Decoding values array as an array of PoolHistoryValue
    
    enum CodingKeys: String, CodingKey {
        case metric
        case values
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the "values" as an array of PoolHistoryValue objects
        self.values = try container.decode([PoolHistoryValue].self, forKey: .values)
    }
}

// Top-level structure of the response
struct PoolHistoryResponse: Decodable {
    let result: [PoolHistoryValues]
}
