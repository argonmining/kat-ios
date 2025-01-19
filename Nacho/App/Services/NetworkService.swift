import Alamofire
import Foundation

// Protocol for the NetworkService
protocol NetworkServiceProvidable: AnyObject {
    func fetchTokenList() async throws -> [TokenDeployInfo]
    func fetchTokenInfo(ticker: String) async throws -> TokenDeployInfo
    func fetchTokenPriceInfo(ticker: String) async throws -> TokenInfoResponse
    func fetchTokenChartResponse(ticker: String) async throws -> TokenChartResponse
    func fetchHolders(ticker: String) async throws -> [HolderInfo]
    func fetchMintHeatmapForWeek() async throws -> [MintInfo]
}

// NetworkService implementation
final class NetworkService: NetworkServiceProvidable {

    private let baseURL = Constants.baseUrl
    private let kasfyiBaseURL = Constants.kasfyiBaseUrl

    func fetchTokenList() async throws -> [TokenDeployInfo] {
        // TODO: Consider to expose it as a parameter in the function
        let parameters: [String: Any] = ["limit": 4000]

        let dataTask = AF.request(baseURL + Endpoint.tokenList.value, parameters: parameters)
            .validate()
            .serializingDecodable(ResponseWrapper<[TokenDeployInfo]>.self)

        do {
            let response = try await dataTask.value
            return response.result
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchTokenInfo(ticker: String) async throws -> TokenDeployInfo {
        let dataTask = AF.request(baseURL + Endpoint.tokenInfo(ticker).value)
            .validate()
            .serializingDecodable(ResponseWrapper<TokenDeployInfo>.self)

        do {
            let response = try await dataTask.value
            return response.result
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    // Fetch Price data for KRC20 token from kas.fyi
    // TODO: Probably should have a katapi request for it
    func fetchTokenPriceInfo(ticker: String) async throws -> TokenInfoResponse {
        let dataTask = AF.request(kasfyiBaseURL + Endpoint.tokenPriceInfo(ticker).value)
            .validate()
            .serializingDecodable(TokenInfoResponse.self)

        do {
            let response = try await dataTask.value
            return response
        } catch {
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchTokenChartResponse(ticker: String) async throws -> TokenChartResponse {
        let dataTask = AF.request(kasfyiBaseURL + Endpoint.tokenChart(ticker).value)
            .validate()
            .serializingDecodable(TokenChartResponse.self)
        do {
            let response = try await dataTask.value
            return response
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchHolders(ticker: String) async throws -> [HolderInfo] {
        let dataTask = AF.request(kasfyiBaseURL + Endpoint.tokenInfoNoChart(ticker).value)
            .validate()
            .serializingDecodable(HoldersResponse.self)
        do {
            let response = try await dataTask.value
            return response.holders
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchMintHeatmapForWeek() async throws -> [MintInfo] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let now = Date()
        guard let weekBefore = Calendar.current.date(byAdding: .day, value: -7, to: now) else {
            throw NetworkError.somethingWentWrong
        }
        let nowString = formatter.string(from: now)
        let weekBeforeString = formatter.string(from: weekBefore)
        print(nowString)
        print(weekBeforeString)
        let parameters: [String: Any] = ["startDate": weekBeforeString, "endDate": nowString]

        let dataTask = AF.request(baseURL + Endpoint.tokensMintTotal.value, parameters: parameters)
            .validate()
            .serializingDecodable([MintInfo].self)

        do {
            return try await dataTask.value
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }
}

private extension NetworkService {

    enum Endpoint {
        case tokenList
        case tokenInfo(String)
        case tokenPriceInfo(String)
        case tokenChart(String)
        case tokenInfoNoChart(String)
        case tokensMintTotal

        var value: String {
            switch self {
            case .tokenList: return "/token/tokenlist"
            case .tokenInfo(let ticker): return "/token/\(ticker)"
            case .tokenPriceInfo(let ticker): return "/token/krc20/\(ticker)/info"
            case .tokenChart(let ticker): return "/token/krc20/\(ticker)/charts?type=candles&interval=1d"
            case .tokenInfoNoChart(let ticker): return "/token/krc20/\(ticker)/info?includeCharts=false"
            case .tokensMintTotal: return "/minting/mint-totals"
            }
        }
    }

    // Response wrapper for the JSON structure
    struct ResponseWrapper<T: Decodable>: Decodable {
        let result: T
    }
}
