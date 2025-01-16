import SwiftUI
import Observation

@Observable
final class HomeViewModel {

    var tokenPriceData: TokenPriceData? = nil
    var chartData: [ChartTradeItem]? = nil

    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }

    func fetchPriceInfo() async {
        do {
            async let infoResponse = networkService.fetchTokenPriceInfo(ticker: "NACHO")
            async let chartResponse = networkService.fetchTokenChartResponse(ticker: "NACHO")
            let result = try (await infoResponse, await chartResponse)
            await MainActor.run {
                self.tokenPriceData = TokenPriceData(fromTokenInfoResponse: result.0)
                self.chartData = result.1.candles
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
        }
    }
}
