import SwiftUI
import Observation

@Observable
final class KatPoolViewModel {

    var blocks: Double? = nil
    var blocks24h: Double? = nil
    var minersChartData: [DonutChartDS.ChartData]? = nil
    var minersCount: Double? = nil
    var hashrateChartData: [LineChartDS.ChartData]? = nil
    var kasPayoutChartData: [LineChartDS.ChartData]? = nil
    var nachoPayoutChartData: [LineChartDS.ChartData]? = nil
    var latestPayouts: [PoolPayout]? = nil
    var isLoading: Bool = false
    var hashrateTimeInterval: Int = 7
    var payoutsTimeInterval: Int = 7
    // Addresses
    var addressModels: [AddressModel] = []
    // Updated to store workers, kasPayoutsSum, nachoPayoutsSum, and hashrateData
    var addressWorkers: [String: ([WorkerHashRateDTO], Double?, Double?, [LineChartDS.ChartData]?)] = [:]
    var addressesLoading: Bool = false
    var showAddresses: Bool = false
    var addressWorkersViewPresented: Bool = false
    var addressWorkersViewModel: AddressWorkersViewModel? = nil

    private let dataProvider: DataProvidable
    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        self.networkService = networkService
        self.dataProvider = dataProvider
        refresh()
    }

    func refresh() {
        checkAddresses()
        isLoading = true
        Task {
            await fetchBlocksInfo()
            await MainActor.run {
                self.isLoading = false
            }
        }
    }

    func selectAddress(_ address: String) {
        guard let workers = addressWorkers[address] else { return }
        addressWorkersViewModel = AddressWorkersViewModel(
            address: address,
            workers: workers.0,
            networkService: networkService
        )
        addressWorkersViewPresented = true
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
                await self.fetchAddressData(addressModels.compactMap(\.address))
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

    func fetchAddressData(_ addresses: [String]) async {
        await withTaskGroup(of: (String, [WorkerHashRateDTO]?, Double?, Double?, [LineChartDS.ChartData]?).self) { group in
            for address in addresses {
                group.addTask { [weak self] in
                    do {
                        let workers = try await self?.networkService.fetchWorkersHashRate(address: address)
                        let payouts = try await self?.networkService.fetchKatPoolAddressPayouts(address: address)
                        let kasPayoutsSum = payouts?.filter { $0.amountType == .kas }.reduce(0) { $0 + $1.amount }
                        let nachoPayoutsSum = payouts?.filter { $0.amountType == .nacho }.reduce(0) { $0 + $1.amount }
                        let history = try await self?.networkService.fetchKatPoolAddressHistory(address: address, range: 7).compactMap({$0.toChartDataItem()})
                        return (address, workers, kasPayoutsSum, nachoPayoutsSum, history)
                    } catch {
                        print("Failed to fetch workers for address \(address): \(error)")
                        return (address, nil, nil, nil, nil)
                    }
                }
            }
            var results: [String: ([WorkerHashRateDTO], Double?, Double?, [LineChartDS.ChartData]?)] = [:]
            for await (address, workers, kasPayoutsSum, nachoPayoutsSum, history) in group {
                var resultData: ([WorkerHashRateDTO], Double?, Double?, [LineChartDS.ChartData]?) = ([], kasPayoutsSum, nachoPayoutsSum, history)
                if let workers = workers {
                    resultData.0 = workers
                    results[address] = resultData
                }
            }
            self.addressWorkers = results
        }
    }

    func fetchBlocksInfo() async {
        guard blocks == nil, blocks24h == nil else { return }
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
                let (kasData, nachoData) = self.aggregatePayoutsByTypeAndDay(
                    payouts: result.4,
                    days: self.payoutsTimeInterval
                )
                self.kasPayoutChartData = kasData
                self.nachoPayoutChartData = nachoData
                self.latestPayouts = self.latestPayouts(payouts: result.4, count: 5)
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
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
        kasPayoutChartData = nil
        nachoPayoutChartData = nil
        do {
            let response = try await networkService.fetchKatPoolPayouts()
            await MainActor.run {
                let (kasData, nachoData) = self.aggregatePayoutsByTypeAndDay(
                    payouts: response,
                    days: self.payoutsTimeInterval
                )
                self.kasPayoutChartData = kasData
                self.nachoPayoutChartData = nachoData
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

    private func aggregatePayoutsByTypeAndDay(payouts: [PoolPayout], days: Int) -> ([LineChartDS.ChartData], [LineChartDS.ChartData]) {
        let calendar = Calendar.current

        // Filter and group KAS payouts
        let kasPayouts = payouts.filter { $0.amountType == .kas }
        let kasGroupedPayouts = Dictionary(grouping: kasPayouts) { payout in
            let date = Date(timeIntervalSince1970: payout.timestamp / 1000)
            return calendar.startOfDay(for: date).timeIntervalSince1970
        }
        let kasAggregatedData = kasGroupedPayouts.map { (timestamp, payouts) in
            LineChartDS.ChartData(
                id: UUID(),
                timestamp: timestamp,
                value: payouts.reduce(0) { $0 + $1.amount }
            )
        }.sorted { $0.timestamp < $1.timestamp }.suffix(days)

        // Filter and group NACHO payouts
        let nachoPayouts = payouts.filter { $0.amountType == .nacho }
        let nachoGroupedPayouts = Dictionary(grouping: nachoPayouts) { payout in
            let date = Date(timeIntervalSince1970: payout.timestamp / 1000)
            return calendar.startOfDay(for: date).timeIntervalSince1970
        }
        let nachoAggregatedData = nachoGroupedPayouts.map { (timestamp, payouts) in
            LineChartDS.ChartData(
                id: UUID(),
                timestamp: timestamp,
                value: payouts.reduce(0) { $0 + $1.amount }
            )
        }.sorted { $0.timestamp < $1.timestamp }.suffix(days)

        return (Array(kasAggregatedData), Array(nachoAggregatedData))
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
