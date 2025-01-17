import Foundation

final class MockNetworkService: NetworkServiceProvidable {

    func fetchTokenList() async throws -> [TokenDeployInfo] {
        try await Task.sleep(nanoseconds: 3_000_000_000)

        return [
            TokenDeployInfo(
                tick: "NACHO",
                maxSupply: 287000000,
                limit: 2870000,
                preMinted: 0,
                minted: 287000000,
                holdersTotal: 17752,
                mintTotal: 9998095,
                logoPath: "/logos/NACHO.jpg",
                releaseTimeInterval: 1737025209359
            ),
            TokenDeployInfo(
                tick: "KDAO",
                maxSupply: 150000000,
                limit: 10000000,
                preMinted: 0,
                minted: 150000000,
                holdersTotal: 8691,
                mintTotal: 14975122,
                logoPath: "/logos/KDAO.jpg",
                releaseTimeInterval: 1737025209359
            ),
            TokenDeployInfo(
                tick: "KASPER",
                maxSupply: 28700000,
                limit: 2870000,
                preMinted: 0,
                minted: 28700000,
                holdersTotal: 7113,
                mintTotal: 999614,
                logoPath: "/logos/KASPER.jpg",
                releaseTimeInterval: 1737025209359
            ),
            TokenDeployInfo(
                tick: "GHOAD",
                maxSupply: 4000000,
                limit: 7680000,
                preMinted: 2800000,
                minted: 4000000,
                holdersTotal: 6923,
                mintTotal: 156250,
                logoPath: "/logos/GHOAD.jpg",
                releaseTimeInterval: 1737025209359
            )
        ]
    }

    func fetchTokenPriceInfo(ticker: String) async throws -> TokenInfoResponse {
        try await Task.sleep(nanoseconds: 3_000_000_000)

        return TokenInfoResponse(
            ticker: "NACHO",
            holderTotal: 20000,
            transferTotal: 340000,
            price: .init(
                priceInUsd: 0.000008765,
                marketCapInUsd: 18876534.834223,
                change24h: 3.4564
            ),
            tradeVolume: .init(amountInUsd: 658345)
        )
    }

    func fetchTokenChartResponse(ticker: String) async throws -> TokenChartResponse {
        try await Task.sleep(nanoseconds: 3_000_000_000)

        return TokenChartResponse(candles: [
            ChartTradeItem(timestamp: 1673500000, value: 0.00008575),
            ChartTradeItem(timestamp: 1673503600, value: 0.00008629),
            ChartTradeItem(timestamp: 1673507200, value: 0.00008757),
            ChartTradeItem(timestamp: 1673510800, value: 0.00008739)
        ])
    }
}
