import SwiftUI
import Observation

@Observable
final class TickerGridViewModel {

    var tickers: [MintInfo]?
    var showMap: Bool = true
    private let networkService: NetworkServiceProvidable
    private var onTickerSelected: (String) -> Void
    private var onTickerLoaded: ([MintInfo]?) -> Void

    init(
        networkService: NetworkServiceProvidable,
        tickers: [MintInfo]? = nil,
        onTickerSelected: @escaping (String) -> Void,
        onTickersLoaded: @escaping ([MintInfo]?) -> Void
    ) {
        self.networkService = networkService
        self.tickers = tickers
        self.onTickerSelected = onTickerSelected
        self.onTickerLoaded = onTickersLoaded
    }

    func onTickerSelected(tick: String) {
        self.onTickerSelected(tick)
    }

    func fetchMintMap() async {
        guard tickers == nil else { return }
        do {
            let response = try await networkService.fetchMintHeatmapForWeek()
            await MainActor.run {
                self.tickers = response
                    .filter { $0.mintTotal > 0 }
                    .sorted(by: { $0.mintTotal > $1.mintTotal })
                showMap = true
                self.onTickerLoaded(self.tickers)
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
            showMap = false
        }
    }
}
