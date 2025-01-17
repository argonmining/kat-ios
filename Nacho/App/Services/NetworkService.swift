import Alamofire

// Protocol for the NetworkService
protocol NetworkServiceProvidable: AnyObject {
    func fetchTokenList() async throws -> [TokenDeployInfo]
    func fetchTokenPriceInfo(ticker: String) async throws -> TokenInfoResponse
    func fetchTokenChartResponse(ticker: String) async throws -> TokenChartResponse
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
}

private extension NetworkService {

    enum Endpoint {
        case tokenList
        case tokenPriceInfo(String)
        case tokenChart(String)

        var value: String {
            switch self {
            case .tokenList: return "/token/tokenlist"
            case .tokenPriceInfo(let ticker): return "/token/krc20/\(ticker)/info"
            case .tokenChart(let ticker): return "/token/krc20/\(ticker)/charts?type=candles&interval=1d"
            }
        }
    }

    // Response wrapper for the JSON structure
    struct ResponseWrapper<T: Decodable>: Decodable {
        let result: T
    }
}
