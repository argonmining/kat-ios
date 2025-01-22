import SwiftUI
import Observation

@Observable
final class CompareTokensViewModel {

    var tokens: [String]
    var token1: String?
    var token2: String?
    var isFirstToken: Bool = true
    var showTokenSelection: Bool = false
    var showTradeInfo1: Bool = false
    var tokenPriceData1: TokenPriceData? = nil
    var chartData1: [ChartTradeItem]? = nil
    var showTradeInfo2: Bool = false
    var tokenPriceData2: TokenPriceData? = nil
    var chartData2: [ChartTradeItem]? = nil
    var token1Loading: Bool = false
    var token2Loading: Bool = false
    private let tokensInfo: [TokenDeployInfo]
    private let networkService: NetworkServiceProvidable

    init(tokensInfo: [TokenDeployInfo], networkService: NetworkServiceProvidable) {
        self.tokensInfo = tokensInfo
        self.networkService = networkService
        self.tokens = tokensInfo.compactMap { $0.tick }
    }

    func token1Holders() -> String {
        guard let token1 else { return "-" }
        guard let holders = tokensInfo.filter({ $0.tick == token1 }).first?.holdersTotal else {
            return "-"
        }
        return Formatter.formatToNumber(value: holders)
    }

    func token2Holders() -> String {
        guard let token2 else { return "-" }
        guard let holders = tokensInfo.filter({ $0.tick == token2 }).first?.holdersTotal else {
            return "-"
        }
        return Formatter.formatToNumber(value: holders)
    }

    func isLoading() -> Bool {
        return token1Loading || token2Loading
    }

    func onTokensUpdated() {
        guard token1 != nil, token2 != nil else { return }
        tokenPriceData1 = nil
        tokenPriceData2 = nil
        chartData1 = nil
        chartData2 = nil
        Task {
            await fetchPriceInfo1()
            await fetchPriceInfo2()
        }
    }

    private func fetchPriceInfo1() async {
        guard let ticker = token1 else { return }
        token1Loading = true
        do {
            async let infoResponse = networkService.fetchTokenPriceInfo(ticker: ticker)
            async let chartResponse = networkService.fetchTokenChartResponse(ticker: ticker)
            let result = try (await infoResponse, await chartResponse)
            await MainActor.run {
                self.tokenPriceData1 = TokenPriceData(fromTokenInfoResponse: result.0)
                self.chartData1 = result.1.candles
//                print("ChartData1: \(self.chartData1!)")
                token1Loading = false
            }
        } catch {
            // TODO: Add error handling
            showTradeInfo1 = false
            token1Loading = false
            print("Error: \(error)")
        }
    }

    private func fetchPriceInfo2() async {
        guard let ticker = token2 else { return }
        token2Loading = true
        do {
            async let infoResponse = networkService.fetchTokenPriceInfo(ticker: ticker)
            async let chartResponse = networkService.fetchTokenChartResponse(ticker: ticker)
            let result = try (await infoResponse, await chartResponse)
            await MainActor.run {
                self.tokenPriceData2 = TokenPriceData(fromTokenInfoResponse: result.0)
                self.chartData2 = result.1.candles
//                print("ChartData2: \(self.chartData2!)")
                token2Loading = false
            }
        } catch {
            // TODO: Add error handling
            showTradeInfo2 = false
            token2Loading = false
            print("Error: \(error)")
        }
    }
}
