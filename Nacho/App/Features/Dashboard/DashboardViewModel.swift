//import Foundation
//import Alamofire
//import SwiftUI
//import Observation
//
//@Observable
//final class DashboardViewModel {
//
//    let walletAddress: String = "kaspa:qrwv8ec4fawrrym9tn4lf924z87x8w5qjk56edl3vy4jzmluz4r56ahsalatp"
//    var balance: String = "0.0"
//    var payouts: [Payout] = []
//    var dailySharesData: [DailyShares] = []
//    var metricsData: MetricsData? = nil {
//        didSet {
//            switch metricsData!.result.first!.value[1] {
//            case .double(let value):
//                print(value)
//            case .string(let value):
//                let _balance = Double(value)! / 100_000_000
//                balance = String(format: "%.2f", _balance)
//            }
//        }
//    }
//
//    func fetchMinerBalance(wallet: String) async throws -> ApiResponse<MetricsData> {
//        // Construct the URL
//        let url = "https://closedbeta.katpool-frontend.pages.dev/api/miner/balance"
//        let parameters: [String: String] = ["wallet": wallet]
//        
//        // Perform the request
//        return try await withCheckedThrowingContinuation { continuation in
//            AF.request(url, parameters: parameters)
//                .validate()
//                .responseDecodable(of: ApiResponse<MetricsData>.self) { response in
//                    switch response.result {
//                    case .success(let apiResponse):
//                        continuation.resume(returning: apiResponse)
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                    }
//                }
//        }
//    }
//
//    func fetchPoolPayouts() async throws -> ApiResponse<[Payout]> {
//        let url = "https://closedbeta.katpool-frontend.pages.dev/api/pool/payouts"
//
//        return try await withCheckedThrowingContinuation { continuation in
//            AF.request(url)
//                .validate()
//                .responseDecodable(of: ApiResponse<[Payout]>.self) { response in
//                    switch response.result {
//                    case .success(let apiResponse):
//                        continuation.resume(returning: apiResponse)
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                    }
//                }
//        }
//    }
//
//    func fetchSharesHistory(wallet: String) async throws -> [DailyShares] {
//        let url = "https://closedbeta.katpool-frontend.pages.dev/api/miner/sharesHistory?wallet=\(walletAddress)"
//
//        return try await withCheckedThrowingContinuation { continuation in
//            AF.request(url)
//                .validate()
//                .responseDecodable(of: ApiResponse<SharesDataResult>.self) { response in
//                switch response.result {
//                case .success(let result):
//                    // Process the shares and group them by day
//                    let allShares = result.data.result.flatMap { $0.values }
//                    let dailyShares = self.groupSharesByDay(allShares)
//                    print(dailyShares)
//                    continuation.resume(returning: dailyShares)
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//
//    func groupSharesByDay(_ shares: [[Value]]) -> [DailyShares] {
//        var groupedShares: [String: Double] = [:]
//
//        // Process each share entry and group by date
//        for share in shares {
//            var timestamp: Double
//            switch share[0] {
//            case .double(let value):
//                timestamp = value
//            case .string(_):
//                timestamp = 0
//            }
//            var amount: Double
//            switch share[1] {
//            case .double(_):
//                amount = 0
//            case .string(let value):
//                amount = Double(value) ?? 0
//            }
//
//            // Convert timestamp to Date
//            let date = Date(timeIntervalSince1970: timestamp)
//
//            // Get the day part of the date (using only year, month, and day)
//            let calendar = Calendar.current
//            let dayKey = calendar.startOfDay(for: date)
//            print(dayKey)
//
//            // Accumulate shares per day
//            groupedShares[dayKey.description, default: 0] += amount
//        }
//
//        // Convert the grouped shares into an array of DailyShares
//        let dailyShares = groupedShares.map { entry in
//            // Convert the string (entry.key) back to a Date object
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            
//            if let date = dateFormatter.date(from: entry.key) {
//                return DailyShares(date: date, totalShares: entry.value)
//            } else {
//                // Handle the error gracefully if date parsing fails
//                return DailyShares(date: Date(), totalShares: entry.value)
//            }
//        }
//
//        // Sort by date
//        return dailyShares.sorted { $0.date < $1.date }
//    }
//}
//
//// https://closedbeta.katpool-frontend.pages.dev/api/miner/balance?wallet=kaspa:qrwv8ec4fawrrym9tn4lf924z87x8w5qjk56edl3vy4jzmluz4r56ahsalatp
////https://closedbeta.katpool-frontend.pages.dev/api/pool/payouts
//
//struct DailyShares {
//    let date: Date
//    let totalShares: Double
//}
//
//// Generic container for the response
//struct ApiResponse<T: Codable>: Codable {
//    let status: String
//    let data: T
//}
//
//struct SharesDataResult: Codable {
//    let resultType: String
//    let result: [ShareEntry]
//}
//
//struct ShareEntry: Codable {
//    let metric: Metric
//    let values: [[Value]]  // [timestamp, shares]
//}
//
//struct Metric: Codable {
//    let __name__: String
//    let wallet_address: String
//}
//
//// Specific structure for the "data" field
//struct MetricsData: Codable {
//    let resultType: String
//    let result: [MetricResult]
//}
//
//// Specific data structure for pool payouts
//struct Payout: Codable {
//    let walletAddress: String
//    let amount: Double
//    let timestamp: Int
//    let transactionHash: String
//}
//
//// Represents each result in the "result" array
//struct MetricResult: Codable {
//    let metric: MetricInfo
//    let value: [Value]
//}
//
//// Metric information
//struct MetricInfo: Codable {
//    let __name__: String
//    let instance: String
//    let job: String
//    let wallet: String
//    
//    enum CodingKeys: String, CodingKey {
//        case __name__ = "__name__"
//        case instance, job, wallet
//    }
//}
//
//// Represents the "value" array
//typealias Value = CodableValue
//
//enum CodableValue: Codable {
//    case double(Double)
//    case string(String)
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let doubleValue = try? container.decode(Double.self) {
//            self = .double(doubleValue)
//        } else if let stringValue = try? container.decode(String.self) {
//            self = .string(stringValue)
//        } else {
//            throw DecodingError.typeMismatch(CodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid value type"))
//        }
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .double(let value):
//            try container.encode(value)
//        case .string(let value):
//            try container.encode(value)
//        }
//    }
//}
