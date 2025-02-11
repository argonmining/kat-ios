import Foundation

struct WorkerHashRateDTO: Decodable, Hashable {
    let minerID: String
    let address: String
    let fifteenMin: Double
    let oneHour: Double
    let twelveHour: Double
    let twentyFourHour: Double

    enum CodingKeys: String, CodingKey {
        case metric
        case averages
    }

    enum MetricKeys: String, CodingKey {
        case minerID = "miner_id"
        case address = "wallet_address"
    }

    enum AveragesKeys: String, CodingKey {
        case fifteenMin
        case oneHour
        case twelveHour
        case twentyFourHour
    }

    init(
        minerID: String,
        address: String,
        fifteenMin: Double,
        oneHour: Double,
        twelveHour: Double,
        twentyFourHour: Double
    ) {
        self.minerID = minerID
        self.address = address
        self.fifteenMin = fifteenMin
        self.oneHour = oneHour
        self.twelveHour = twelveHour
        self.twentyFourHour = twentyFourHour
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let metricContainer = try container.nestedContainer(keyedBy: MetricKeys.self, forKey: .metric)
        self.minerID = try metricContainer.decode(String.self, forKey: .minerID)
        self.address = try metricContainer.decode(String.self, forKey: .address)
        
        let averagesContainer = try container.nestedContainer(keyedBy: AveragesKeys.self, forKey: .averages)
        self.fifteenMin = try averagesContainer.decode(Double.self, forKey: .fifteenMin)
        self.oneHour = try averagesContainer.decode(Double.self, forKey: .oneHour)
        self.twelveHour = try averagesContainer.decode(Double.self, forKey: .twelveHour)
        self.twentyFourHour = try averagesContainer.decode(Double.self, forKey: .twentyFourHour)
    }
}
