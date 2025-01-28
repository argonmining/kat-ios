import SwiftUI
import Observation

@Observable
final class TokenDetailsViewModel {

    var tokenInfo: TokenDeployInfo
    var tokenPriceData: TokenPriceData? = nil
    var chartData: [LineChartDS.ChartData]? = nil
    var holders: [HolderInfo]? = nil
    var showTradeInfo: Bool = true
    var showHolders: Bool = true

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
                self.chartData = result.1.candles.compactMap({$0.toChartDataItem()})
            }
        } catch {
            // TODO: Add error handling
            showTradeInfo = false
            print("Error: \(error)")
        }
    }

    func fetchTokenHolders() async {
        do {
            let response = try await networkService.fetchHolders(ticker: tokenInfo.tick)
            await MainActor.run {
                self.holders = response
                    .sorted(by: { $0.amount > $1.amount })
                    .prefix(10)
                    .map(\.self)
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
            showHolders = false
        }
    }
}
