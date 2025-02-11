import SwiftUI
import Observation

@Observable
final class KatPoolViewModel {

    var blocks: Double? = nil
    var blocks24h: Double? = nil
    var minersChartData: [DonutChartDS.ChartData]? = nil
    var minersCount: Double? = nil
    var hashrateChartData: [LineChartDS.ChartData]? = nil
    var payoutChartData: [LineChartDS.ChartData]? = nil
    var latestPayouts: [PoolPayout]? = nil
    var isLoading: Bool = false
    var hashrateTimeInterval: Int = 7
    var payoutsTimeInterval: Int = 7
    // Addresses
    var addressModels: [AddressModel] = []
    var addressWorkers: [String: [WorkerHashRateDTO]] = [:]
    var addressesLoading: Bool = false
    var showAddresses: Bool = false
    var addressWorkersViewPresented: Bool = false
    var selectedAddress: String? = nil

    private let dataProvider: DataProvidable
    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        self.networkService = networkService
        self.dataProvider = dataProvider
        checkAddresses()
    }

    func checkAddresses() {
        addressesLoading = true
        Task {
            do {
                let addressModels = try await self.dataProvider.getAddresses().filter { $0.contentTypes.contains(.miners) }
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

    func fetchAddressTokens(_ addresses: [String]) async {
        await withTaskGroup(of: (String, [WorkerHashRateDTO]?).self) { group in
            for address in addresses {
                group.addTask { [weak self] in
                    do {
                        let workers = try await self?.networkService.fetchWorkersHashRate(address: address)
                        return (address, workers)
                    } catch {
                        print("Failed to fetch workers for address \(address): \(error)")
                        return (address, nil)
                    }
                }
            }
            var results: [String: [WorkerHashRateDTO]] = [:]
            for await (address, workers) in group {
                if let workers = workers {
                    results[address] = workers
                }
            }
            self.addressWorkers = results
        }
    }

    func fetchBlocksInfo() async {
        guard blocks == nil, blocks24h == nil else { return }
        isLoading = true
        do {
            async let blocks = networkService.fetchKatPoolBlocks()
            async let blocks24h = networkService.fetchKatPoolBlocks24()
            async let miners = networkService.fetchKatPoolMiners()
            async let history = networkService.fetchKatPoolHistory(range: hashrateTimeInterval)
            async let payouts = networkService.fetchKatPoolPayouts()
            let result = try (
                await blocks,
                await blocks24h,
                await miners,
                await history,
                await payouts
            )
            await MainActor.run {
                self.blocks = result.0.totalBlocks
                self.blocks24h = result.1.totalBlocks24h
                (self.minersChartData, minersCount) = self.chartData(from: result.2)
                self.hashrateChartData = result.3.compactMap({$0.toChartDataItem()})
                self.payoutChartData = self.aggregatePayoutsByDay(
                    payouts: result.4,
                    days: self.payoutsTimeInterval
                )
                self.latestPayouts = self.latestPayouts(payouts: result.4, count: 5)
                isLoading = false
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
            isLoading = false
        }
    }

    func fetchHashrateData() async {
        hashrateChartData = nil
        do {
            let response = try await networkService.fetchKatPoolHistory(range: hashrateTimeInterval)
            await MainActor.run {
                self.hashrateChartData = response.compactMap({$0.toChartDataItem()})
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
        }
    }

    func fetchPayoutData() async {
        payoutChartData = nil
        do {
            let response = try await networkService.fetchKatPoolPayouts()
            await MainActor.run {
                self.payoutChartData = self.aggregatePayoutsByDay(
                    payouts: response,
                    days: self.payoutsTimeInterval
                )
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
        }
    }

    private func chartData(from poolMiners: PoolMiners) -> ([DonutChartDS.ChartData], Double) {
        let totalValue = poolMiners.values.reduce(0, +)
        return (zip(poolMiners.labels.indices, zip(poolMiners.labels, poolMiners.values)).map({ (index, item) in
            let (label, value) = item
            return DonutChartDS.ChartData(
                id: index,
                label: label,
                value: value,
                percentage: value / totalValue,
                color: getColor(for: index)
            )
        }), Double(totalValue))
    }

    private func aggregatePayoutsByDay(payouts: [PoolPayout], days: Int) -> [LineChartDS.ChartData] {
        let calendar = Calendar.current

        let groupedPayouts = Dictionary(grouping: payouts) { payout in
            let date = Date(timeIntervalSince1970: payout.timestamp / 1000)
            return calendar.startOfDay(for: date).timeIntervalSince1970
        }

        let aggregatedData = groupedPayouts.map { (timestamp, payouts) in
            LineChartDS.ChartData(
                id: UUID(),
                timestamp: timestamp,
                value: payouts.reduce(0) { $0 + $1.amount }
            )
        }

        return aggregatedData.sorted { $0.timestamp < $1.timestamp }.suffix(days)
    }

    private func latestPayouts(payouts: [PoolPayout], count: Int) -> [PoolPayout] {
        return payouts
            .sorted { $0.timestamp > $1.timestamp }
            .prefix(count)
            .map { $0 }
    }

    private func getColor(for index: Int) -> Color {
        return index < ChartColors.colors.count ? ChartColors.colors[index] : .gray
    }
}
