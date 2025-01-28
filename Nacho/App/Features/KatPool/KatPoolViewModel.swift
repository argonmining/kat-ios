import SwiftUI
import Observation

@Observable
final class KatPoolViewModel {

    var blocks: Double? = nil
    var blocks24h: Double? = nil
    var minersChartData: [DonutChartDS.ChartData]? = nil
    var minersCount: Double? = nil
    var hashrateChartData: [LineChartDS.ChartData]? = nil
    var isLoading: Bool = false
    var hashrateTimeInterval: Int = 7

    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }

    func fetchBlocksInfo() async {
        guard blocks == nil, blocks24h == nil else { return }
        isLoading = true
        do {
            async let blocks = networkService.fetchKatPoolBlocks()
            async let blocks24h = networkService.fetchKatPoolBlocks24()
            async let miners = networkService.fetchKatPoolMiners()
            async let history = networkService.fetchKatPoolHistory(range: hashrateTimeInterval)
            let result = try (await blocks, await blocks24h, await miners, await history)
            await MainActor.run {
                self.blocks = result.0.totalBlocks
                self.blocks24h = result.1.totalBlocks24h
                (self.minersChartData, minersCount) = self.chartData(from: result.2)
                self.hashrateChartData = result.3.compactMap({$0.toChartDataItem()})
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

    private func getColor(for index: Int) -> Color {
        return index < ChartColors.colors.count ? ChartColors.colors[index] : .gray
    }
}
