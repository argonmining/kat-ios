import SwiftUI
import Observation

@Observable
final class KatScanViewModel {

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
}
