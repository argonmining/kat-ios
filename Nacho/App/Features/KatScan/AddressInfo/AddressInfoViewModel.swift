import SwiftUI
import Observation

@Observable
final class AddressInfoViewModel {

    var address: String = ""
    var isTokensLoading: Bool = false
    var isBalanceLoading: Bool = false
    var isPasteAvailable: Bool = false
    var tokens: [AddressTokenInfo]?
    var addressBalance: AddressBalance?

    private var currentAddress: String = ""
    private let networkService: NetworkServiceProvidable
    private var onTickerSelected: (String) -> Void

    init(
        networkService: NetworkServiceProvidable,
        onTickerSelected: @escaping (String) -> Void
    ) {
        self.networkService = networkService
        self.onTickerSelected = onTickerSelected
        checkClipbaord()
    }

    func checkClipbaord() {
        guard UIPasteboard.general.hasStrings else { return }
        isPasteAvailable = true
    }

    func pasteFromClipboard() {
        guard let text = UIPasteboard.general.string else {
            return
        }
        address = text
        isPasteAvailable = false
    }

    func onTickerSelected(tick: String) {
        self.onTickerSelected(tick)
    }

    func fetchAddressTokens() async {
        print(address)
        guard isValidKaspaAddress(address) else { return }
        guard address != currentAddress else { return }
        isTokensLoading = true
        do {
            let response = try await networkService.fetchAddressTokenList(address: address)
            await MainActor.run {
                currentAddress = address
                tokens = response
                isTokensLoading = false
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
            isTokensLoading = false
        }
    }

    func fetchAddressBalance() async {
        print(address)
        guard isValidKaspaAddress(address) else { return }
        guard address != currentAddress else { return }
        isBalanceLoading = true
        do {
            let response = try await networkService.fetchAddressBalance(address: address)
            await MainActor.run {
                addressBalance = response
                isBalanceLoading = false
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
            isBalanceLoading = false
        }
    }

    func isValidKaspaAddress(_ address: String) -> Bool {
        guard address.hasPrefix("kaspa:") else { return false }
        let addressBody = address.dropFirst(6)
        guard !addressBody.isEmpty else { return false }
        let base32Charset = Set("abcdefghijklmnopqrstuvwxyz0123456789")
        for char in addressBody.lowercased() {
            if !base32Charset.contains(char) {
                return false
            }
        }
        print(address.count)
        let lengthIsValid = (address.count >= 59 && address.count <= 79)
        return lengthIsValid
    }
}
