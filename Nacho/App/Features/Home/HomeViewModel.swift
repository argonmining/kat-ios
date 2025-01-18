import SwiftUI
import Observation

@Observable
final class HomeViewModel {

    var tokenPriceData: TokenPriceData? = nil
    var chartData: [ChartTradeItem]? = nil
    var holders: [HolderInfo]? = nil
    var showHolders: Bool = true

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

    func fetchTokenHolders() async {
        do {
            let response = try await networkService.fetchHolders(ticker: "NACHO")
            print(response.count)
            print(response)
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
