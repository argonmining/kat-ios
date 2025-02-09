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
    func fetchAddressTokenList(address: String) async throws -> [AddressTokenInfo]
    func fetchAddressBalance(address: String) async throws -> AddressBalance
    func fetchKasplexInfo() async throws -> KasplexInfo
    func fetchNFTCollectionInfo(ticker: String) async throws -> NFTCollectionInfo
    func fetchAddressNFTs(address: String) async throws -> [AddressNFTInfoDTO]
    func fetchNFTInfo(hash: String, index: Int) async throws -> NFTInfo
    func fetchKatPoolBlocks() async throws -> PoolBlocks
    func fetchKatPoolBlocks24() async throws -> PoolBlocks24h
    func fetchKatPoolMiners() async throws -> PoolMiners
    func fetchKatPoolHistory(range: Int) async throws -> [PoolHistoryValue]
    func fetchKatPoolPayouts() async throws -> [PoolPayout]
    func fetchAddressTokens(address: String) async throws -> [AddressTokenInfoKasFyiDTO]
}

// NetworkService implementation
final class NetworkService: NetworkServiceProvidable {

    private let baseURL = Constants.baseUrl
    private let kasfyiBaseURL = Constants.kasfyiBaseUrl
    private let kasplexBaseURL = Constants.kasplexBaseUrl
    private let kaspaOrgBaseURL = Constants.kaspaOrgBaseUrl
    private let nftUrl = Constants.nftKatscanUrl
    private let nftCacheUrl = Constants.nftCachUrl
    private let katPoolUrl = Constants.katPoolUrl

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
            print(error)
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

    func fetchAddressTokenList(address: String) async throws -> [AddressTokenInfo] {
        let dataTask = AF.request(kasplexBaseURL + Endpoint.addressTokenList(address).value)
            .validate()
            .serializingDecodable(ResponseWrapper<[AddressTokenInfo]>.self)

        do {
            let response = try await dataTask.value
            return response.result
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchAddressBalance(address: String) async throws -> AddressBalance {
        let dataTask = AF.request(kaspaOrgBaseURL + Endpoint.addressBalance(address).value)
            .validate()
            .serializingDecodable(AddressBalance.self)

        do {
            let response = try await dataTask.value
            return response
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchKasplexInfo() async throws -> KasplexInfo {
        let dataTask = AF.request(kasplexBaseURL + Endpoint.kasplexInfo.value)
            .validate()
            .serializingDecodable(ResponseWrapper<KasplexInfo>.self)

        do {
            let response = try await dataTask.value
            return response.result
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchNFTCollectionInfo(ticker: String) async throws -> NFTCollectionInfo {
        let dataTask = AF.request(nftUrl + Endpoint.nftCollection(ticker).value)
            .validate()
            .serializingDecodable(ResponseWrapper<NFTCollectionInfo>.self)

        do {
            let response = try await dataTask.value
            return response.result
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchAddressNFTs(address: String) async throws -> [AddressNFTInfoDTO] {
        let dataTask = AF.request(nftUrl + Endpoint.addressNfts(address).value)
            .validate()
            .serializingDecodable(ResponseWrapper<[AddressNFTInfoDTO]>.self)
        
        do {
            let response = try await dataTask.value
            return response.result
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchNFTInfo(hash: String, index: Int) async throws -> NFTInfo {
        let dataTask = AF.request(nftCacheUrl + Endpoint.nftInfo(hash, index).value)
            .validate()
            .serializingDecodable(NFTInfo.self)

        do {
            let response = try await dataTask.value
            return response
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchKatPoolBlocks() async throws -> PoolBlocks {
        let dataTask = AF.request(katPoolUrl + Endpoint.blocks.value)
            .validate()
            .serializingDecodable(DataResponseWrapper<PoolBlocks>.self)
        do {
            let response = try await dataTask.value
            return response.data
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchKatPoolBlocks24() async throws -> PoolBlocks24h {
        let dataTask = AF.request(katPoolUrl + Endpoint.blocks24h.value)
            .validate()
            .serializingDecodable(DataResponseWrapper<PoolBlocks24h>.self)
        do {
            let response = try await dataTask.value
            return response.data
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchKatPoolMiners() async throws -> PoolMiners {
        let dataTask = AF.request(katPoolUrl + Endpoint.miners.value)
            .validate()
            .serializingDecodable(DataResponseWrapper<PoolMiners>.self)
        do {
            let response = try await dataTask.value
            return response.data
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchKatPoolHistory(range: Int) async throws -> [PoolHistoryValue] {
        let parameters: [String: Any] = ["range": "\(range)d"]
        let dataTask = AF.request(katPoolUrl + Endpoint.poolHistory.value, parameters: parameters)
            .validate()
            .serializingDecodable(DataResponseWrapper<PoolHistoryRsponse>.self)
        do {
            let response = try await dataTask.value
            guard let values = response.data.result.first?.values else {
                print("Error: can't decode pool history values")
                throw NetworkError.somethingWentWrong
            }
            return values
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    func fetchKatPoolPayouts() async throws -> [PoolPayout] {
        let dataTask = AF.request(katPoolUrl + Endpoint.payouts.value)
            .validate()
            .serializingDecodable(DataResponseWrapper<[PoolPayout]>.self)
        do {
            let response = try await dataTask.value
            return response.data
        } catch {
            print(error)
            throw NetworkError.somethingWentWrong
        }
    }

    // Address Data

    func fetchAddressTokens(address: String) async throws -> [AddressTokenInfoKasFyiDTO] {
        let dataTask = AF.request(kasfyiBaseURL + Endpoint.addressTokens(address).value)
            .validate()
            .serializingDecodable([AddressTokenInfoKasFyiDTO].self)
        do {
            let response = try await dataTask.value
            return response.self
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
        case addressTokenList(String)
        case addressBalance(String)
        case kasplexInfo
        case nftCollection(String)
        case nftInfo(String, Int)
        case addressNfts(String)
        // Kat Pool
        case blocks
        case blocks24h
        case miners
        case poolHistory
        case payouts
        // Address
        case addressTokens(String)

        var value: String {
            switch self {
            case .tokenList: return "/token/tokenlist"
            case .tokenInfo(let ticker): return "/token/\(ticker)"
            case .tokenPriceInfo(let ticker): return "/token/krc20/\(ticker)/info"
            case .tokenChart(let ticker): return "/token/krc20/\(ticker)/charts?type=candles&interval=1d"
            case .tokenInfoNoChart(let ticker): return "/token/krc20/\(ticker)/info?includeCharts=false"
            case .tokensMintTotal: return "/minting/mint-totals"
            case .addressTokenList(let address): return "/krc20/address/\(address)/tokenlist"
            case .addressBalance(let address): return "/addresses/\(address)/balance"
            case .kasplexInfo: return "/info"
            case .nftCollection(let ticker): return "/nfts/\(ticker)"
            case .nftInfo(let ticker, let index): return "/metadata/\(ticker)/\(index)"
            case .addressNfts(let address): return "/address/\(address)"
            case .blocks: return "/blocks"
            case .blocks24h: return "/blocks24h"
            case .miners: return "/minerTypes"
            case .poolHistory: return "/hashrate/history"
            case .payouts: return "/payouts"
            case .addressTokens(let address): return "/addresses/\(address)/tokens"
            }
        }
    }

    // Response wrapper for the JSON structure
    struct ResponseWrapper<T: Decodable>: Decodable {
        let result: T
    }

    struct DataResponseWrapper<T: Decodable>: Decodable {
        let data: T
    }
}
