import SwiftUI
import Observation

@Observable
final class TokenDetailsViewModel {

    var tokenInfo: TokenDeployInfo
    var tokenPriceData: TokenPriceData? = nil
    var chartData: [ChartTradeItem]? = nil
    var showTradeInfo: Bool = true

    private let networkService: NetworkServiceProvidable

    init(tokenInfo: TokenDeployInfo, networkService: NetworkServiceProvidable) {
        self.tokenInfo = tokenInfo
        self.networkService = networkService
    }

    func fetchPriceInfo() async {
        do {
            async let infoResponse = networkService.fetchTokenPriceInfo(ticker: tokenInfo.tick)
            async let chartResponse = networkService.fetchTokenChartResponse(ticker: tokenInfo.tick)
            let result = try (await infoResponse, await chartResponse)
            await MainActor.run {
                self.tokenPriceData = TokenPriceData(fromTokenInfoResponse: result.0)
                self.chartData = result.1.candles
            }
        } catch {
            // TODO: Add error handling
            showTradeInfo = false
            print("Error: \(error)")
        }
    }
}
