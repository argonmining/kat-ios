import SwiftUI
import Observation

@Observable
final class HomeViewModel {

    var tokenPriceData: TokenPriceData? = nil
    var chartData: [LineChartDS.ChartData]? = nil
    var holders: [HolderInfo]? = nil
    var showHolders: Bool = true
    var walletPresented: Bool = false
    var addressModels: [AddressModel] = []
    var addressTokens: [String: [AddressTokenInfoKasFyiDTO]] = [:]
    var addressesLoading: Bool = false
    var showAddresses: Bool = false
    var addressTokensViewPresented: Bool = false
    var selectedAddress: String? = nil

    let dataProvider: DataProvidable
    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        self.networkService = networkService
        self.dataProvider = dataProvider
        checkAddresses()
    }

    func fetchAddressTokens(_ addresses: [String]) async {
        await withTaskGroup(of: (String, [AddressTokenInfoKasFyiDTO]?).self) { group in
            for address in addresses {
                group.addTask { [weak self] in
                    do {
                        let tokens = try await self?.networkService.fetchAddressTokens(address: address)
                        return (address, tokens)
                    } catch {
                        print("Failed to fetch tokens for address \(address): \(error)")
                        return (address, nil)
                    }
                }
            }
            var results: [String: [AddressTokenInfoKasFyiDTO]] = [:]
            for await (address, tokens) in group {
                if let tokens = tokens {
                    results[address] = tokens
                }
            }
            self.addressTokens = results
        }
    }

    func fetchPriceInfo() async {
        do {
            async let infoResponse = networkService.fetchTokenPriceInfo(ticker: "NACHO")
            async let chartResponse = networkService.fetchTokenChartResponse(ticker: "NACHO")
            let result = try (await infoResponse, await chartResponse)
            await MainActor.run {
                self.tokenPriceData = TokenPriceData(fromTokenInfoResponse: result.0)
                self.chartData = result.1.candles.compactMap({$0.toChartDataItem()})
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
        }
    }

    func fetchTokenHolders() async {
        do {
            let response = try await networkService.fetchHolders(ticker: "NACHO")
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

    func checkAddresses() {
        addressesLoading = true
        Task {
            do {
                let addressModels = try await self.dataProvider.getAddresses().filter { $0.contentTypes.contains(.tokens) }
                if !addressModels.isEmpty {
                    await MainActor.run {
                        showAddresses = true
                    }
                } else {
                    await MainActor.run {
                        showAddresses = false
                    }
                }
                await self.fetchAddressTokens(addressModels.compactMap(\.address))
                await MainActor.run {
                    self.addressModels = addressModels
                    addressesLoading = false
                }
            } catch {
                // TODO: Add error handling
                print("Error: \(error)")
                await MainActor.run {
                    showAddresses = false
                    addressesLoading = false
                }
            }
        }
    }
}
