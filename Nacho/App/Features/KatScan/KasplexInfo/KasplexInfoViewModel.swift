import SwiftUI
import Observation

@Observable
final class KasplexInfoViewModel {

    var kasplexInfo: KasplexInfo?
    var isLoading: Bool = false
    var showPlaceholder: Bool = false
    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }

    func fetchKasplexInfo() async {
        isLoading = true
        do {
            let kasplexInfo = try await networkService.fetchKasplexInfo()
            await MainActor.run {
                isLoading = false
                self.kasplexInfo = kasplexInfo
            }
        } catch {
            isLoading = false
            showPlaceholder = true
            // TODO: Add error handling
            print(error)
        }
    }
}
