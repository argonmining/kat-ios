import SwiftUI
import Observation

@Observable
final class KatScanViewModel {

    var searchText: String = ""
    var tokens: [TokenDeployInfo]? = nil

    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }

    func fetchTokens() async {
        do {
            let response = try await networkService.fetchTokenList()
            await MainActor.run {
                self.tokens = response
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
        }
    }

    func filteredTokens() -> [TokenDeployInfo] {
        guard let tokens else { return [] }
        guard !searchText.isEmpty else { return tokens }
        return tokens.filter {
            $0.tick.lowercased().contains(searchText.lowercased())
        }
    }
}
