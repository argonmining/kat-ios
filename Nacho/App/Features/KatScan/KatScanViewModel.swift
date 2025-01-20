import SwiftUI
import Observation

@Observable
final class KatScanViewModel {

    var searchText: String = ""
    var tokens: [TokenDeployInfo]? = nil
    var filteredTokens: [TokenDeployInfo] = []
    var selectedTokenViewModel: TokenDetailsViewModel? = nil
    var tickerGridViewModel: TickerGridViewModel? = nil
    var addressInfoViewModel: AddressInfoViewModel? = nil
    var showDetails: Bool = false
    var showFilter: Bool = false
    var showMintMap: Bool = false
    var showAddressInfo: Bool = false
    var isFiltering: Bool = false
    var filterState: TokensFilterState = .none
    var isEmpty: Bool = false
    private var tickers: [MintInfo]? = nil

    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }

    func onShowMintMapAction() {
        tickerGridViewModel = TickerGridViewModel(
            networkService: networkService,
            tickers: tickers,
            onTickerSelected: { [weak self] ticker in
                guard let self = self else { return }
                self.showMintMap = false
                if let tokenInfo = tokens?.filter({$0.tick == ticker}).first {
                    selectedTokenViewModel = TokenDetailsViewModel(
                        tokenInfo: tokenInfo,
                        networkService: self.networkService
                    )
                    self.showDetails = true
                }
                tickerGridViewModel = nil
            }, onTickersLoaded: { [weak self] tickers in
                guard let self = self else { return }
                self.tickers = tickers
            }
        )
        showMintMap = true
    }

    func onShowAddressInfoAction() {
        addressInfoViewModel = AddressInfoViewModel(networkService: networkService) { [weak self] ticker in
            guard let self = self else { return }
            self.showAddressInfo = false
            if let tokenInfo = tokens?.filter({$0.tick == ticker}).first {
                selectedTokenViewModel = TokenDetailsViewModel(
                    tokenInfo: tokenInfo,
                    networkService: self.networkService
                )
                self.showDetails = true
            }
            addressInfoViewModel = nil
        }
        showAddressInfo = true
    }

    func onFilterStateChange() {
        showFilter = false
        switch filterState {
        case .none: isFiltering = false
        default: isFiltering = true
        }
        filterTokens()
    }

    func onItemTap(item: TokenDeployInfo) {
        selectedTokenViewModel = TokenDetailsViewModel(
            tokenInfo: item,
            networkService: networkService
        )
        showDetails = true
    }

    func fetchTokens() async {
        do {
            let response = try await networkService.fetchTokenList()
            await MainActor.run {
                self.tokens = response
                self.filterTokens()
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
        }
    }

    func filterTokens() {
        defer {
            if tokens == nil {
                isEmpty = false
            } else {
                isEmpty = filteredTokens.isEmpty
            }
        }
        guard let tokens else {
            filteredTokens = []
            return
        }
        if !searchText.isEmpty {
            filteredTokens = tokens.filter {
                $0.tick.lowercased().contains(searchText.lowercased())
            }
        } else {
            switch filterState {
            case .none: filteredTokens = tokens
            case .fairMint: filteredTokens = filteredByFairMint(tokens: tokens)
            case .preMint: filteredTokens = filteredByPreMint(tokens: tokens)
            case .mintInProgress: filteredTokens = filteredByMintInProgress(tokens: tokens)
            }
        }
    }

    // MARK: private

    private func filteredByFairMint(tokens: [TokenDeployInfo]) -> [TokenDeployInfo] {
        return tokens.filter { $0.preMinted == 0 }
    }

    private func filteredByPreMint(tokens: [TokenDeployInfo]) -> [TokenDeployInfo] {
        return tokens.filter { $0.preMinted > 0 }
    }

    private func filteredByMintInProgress(tokens: [TokenDeployInfo]) -> [TokenDeployInfo] {
        return tokens.filter { $0.preMinted + $0.minted < $0.maxSupply }
    }
}
