import Observation

@Observable
class AddressWorkersViewModel {

    let address: String
    let workers: [WorkerHashRateDTO]

    var hashrateChartData: [LineChartDS.ChartData]? = nil
    var payouts: [PoolAddressPayoutDTO]? = nil
    var kasPayoutsSum: Double? = nil
    var nachoPayoutsSum: Double? = nil
    var isLoading: Bool = false
    var hashrateTimeInterval: Int = 7

    private let networkService: NetworkServiceProvidable

    init(
        address: String,
        workers: [WorkerHashRateDTO],
        networkService: NetworkServiceProvidable
    ) {
        self.address = address
        self.workers = workers
        self.networkService = networkService
    }

    func fetchInfo() async {
        isLoading = true
        do {
            async let history = networkService.fetchKatPoolAddressHistory(
                address: address,
                range: hashrateTimeInterval
            )
            async let payouts = networkService.fetchKatPoolAddressPayouts(address: address)
            let result = try (
                await history,
                await payouts
            )
            await MainActor.run {
                self.hashrateChartData = result.0.compactMap({$0.toChartDataItem()})
                self.payouts = result.1.sorted { $0.timestamp > $1.timestamp }
                self.kasPayoutsSum = self.payouts?.filter { $0.amountType == .kas }.reduce(0) { $0 + $1.amount }
                self.nachoPayoutsSum = self.payouts?.filter { $0.amountType == .nacho }.reduce(0) { $0 + $1.amount }
                isLoading = false
            }
        } catch {
            // TODO: Add error handling
            print("Error: \(error)")
            isLoading = false
        }
    }
}
