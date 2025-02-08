import Foundation

final class MockNetworkService: NetworkServiceProvidable {

    func fetchTokenList() async throws -> [TokenDeployInfo] {
        try await Task.sleep(nanoseconds: 2_000_000_000)

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

    func fetchTokenInfo(ticker: String) async throws -> TokenDeployInfo {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return TokenDeployInfo(
            tick: "NACHO",
            maxSupply: 287000000,
            limit: 2870000,
            preMinted: 0,
            minted: 287000000,
            holdersTotal: 17752,
            mintTotal: 9998095,
            logoPath: "/logos/NACHO.jpg",
            releaseTimeInterval: 1737025209359,
            holders: [
                .init(
                    address: "kaspa:qrn9k3sz4fkzmaf7608yntvx8pav6a75g240pj40sqp27zcztnr3jmfx85yye",
                    amount: 17500
                ),
                .init(
                    address: "kaspa:qz46qj2e5xe0chxfarxfkppjvzg6thn3xsjpnfum4tgu0ew2ckajyc7x05se3",
                    amount: 25801300
                ),
                .init(
                    address: "kaspa:qpyzs5yqaystvrr6nf5p6cswj3zgjrxfghv58m2qc5ufh8324ve370a2k5340",
                    amount: 828900
                )
            ]
        )
    }

    func fetchTokenPriceInfo(ticker: String) async throws -> TokenInfoResponse {
        try await Task.sleep(nanoseconds: 2_000_000_000)

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
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return TokenChartResponse(candles: [
            ChartTradeItem(timestamp: 1673500000, value: 0.00008575),
            ChartTradeItem(timestamp: 1673503600, value: 0.00008629),
            ChartTradeItem(timestamp: 1673507200, value: 0.00008757),
            ChartTradeItem(timestamp: 1673510800, value: 0.00008739)
        ])
    }

    func fetchHolders(ticker: String) async throws -> [HolderInfo] {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return [
            .init(
                address: "kaspa:qrn9k3sz4fkzmaf7608yntvx8pav6a75g240pj40sqp27zcztnr3jmfx85yye",
                amount: 17500
            ),
            .init(
                address: "kaspa:qz46qj2e5xe0chxfarxfkppjvzg6thn3xsjpnfum4tgu0ew2ckajyc7x05se3",
                amount: 25801300
            ),
            .init(
                address: "kaspa:qpyzs5yqaystvrr6nf5p6cswj3zgjrxfghv58m2qc5ufh8324ve370a2k5340",
                amount: 828900
            )
        ]
    }

    func fetchMintHeatmapForWeek() async throws -> [MintInfo] {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return [
            .init(tick: "NACHO", mintTotal: 34000),
            .init(tick: "GHOAD", mintTotal: 2400),
            .init(tick: "KASPER", mintTotal: 6232)
        ]
    }

    func fetchAddressTokenList(address: String) async throws -> [AddressTokenInfo] {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return [
            .init(ticker: "NACHO", balance: 34000, locked: 0),
            .init(ticker: "GHOAD", balance: 34000, locked: 0),
            .init(ticker: "KASPER", balance: 34000, locked: 0)
        ]
    }

    func fetchAddressBalance(address: String) async throws -> AddressBalance {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(
            address: "kaspa:qr2x6lnhqe75qgcjvcbcvbulmu7rt077kwerwerrtq3qjxh6tdfcgdfg",
            balance: 453423423344
        )
    }

    func fetchKasplexInfo() async throws -> KasplexInfo {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(
            opTotal: 109633496,
            tokenTotal: 1861,
            feeTotal: 127686124.74309599
        )
    }

    func fetchNFTCollectionInfo(ticker: String) async throws -> NFTCollectionInfo {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(
            deployer: "kaspatest:qrks6nxgcwl5agrzzlsv7jxjmezfvhv76k2szv23esf7ksay23jeyyqu9nraq",
            royaltyTo: "kaspatest:qrks6nxgcwl5agrzzlsv7jxjmezfvhv76k2szv23esf7ksay23jeyyqu9nraq",
            buri: "ipfs://bafybeibg2od46rrhgayb2xfaxsrsgnesgbo6palsxypyz7jmcd544wskl4",
            max: 1000,
            royaltyFee: 220000000000,
            daaMintStart: 0,
            premint: 10,
            tick: "NKTTWO",
            mtsAdd: 1737507750.996,
            minted: 1000,
            state: "deployed",
            mtsmod: 1737646511.724
        )
    }

    func fetchNFTInfo(hash: String, index: Int) async throws -> NFTInfo {
        try await Task.sleep(nanoseconds: 2_000)
        return .init(
            name: "Nacho Kats #1",
            description: "trial 9",
            image: "ipfs://bafybeicjnult4hnzcyiwna2a5lpwing2mtmxpnch7winppipbwtfaij55y/1.png",
            edition: 1,
            attributes: [
                .init(traitType: "Head", value: "Jester Hat"),
                .init(traitType: "Face", value: "Cat Eye Glasses"),
                .init(traitType: "Mood", value: "Confident"),
                .init(traitType: "Collar", value: "Dog Tags"),
                .init(traitType: "Outfit", value: "Lab Coat"),
                .init(traitType: "Role", value: "Keeper"),
                .init(traitType: "Tail", value: "Base"),
                .init(traitType: "Background", value: "Orange")
            ]
        )
    }

    func fetchKatPoolBlocks() async throws -> PoolBlocks {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(totalBlocks: 140)
    }

    func fetchKatPoolBlocks24() async throws -> PoolBlocks24h {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(totalBlocks24h: 11)
    }

    func fetchKatPoolMiners() async throws -> PoolMiners {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(
            labels: ["IceRiver", "Bitmain", "GoldShell"],
            values: [95, 10, 8]
        )
    }

    func fetchKatPoolHistory(range: Int) async throws -> [PoolHistoryValue] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return [
            PoolHistoryValue(timestamp: 1737484553.0, hashRate: 190104.81893454556),
            PoolHistoryValue(timestamp: 1737488153.0, hashRate: 186638.58068274715),
            PoolHistoryValue(timestamp: 1737491753.0, hashRate: 208658.48159911227),
            PoolHistoryValue(timestamp: 1737495353.0, hashRate: 251361.32375737873),
            PoolHistoryValue(timestamp: 1737498953.0, hashRate: 255225.97633716525)
        ]
    }

    func fetchKatPoolPayouts() async throws -> [PoolPayout] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return [
            PoolPayout(
                walletAddress: "kaspa:qqmvwmdq68a6tcv4taefqv7puavlnx0quakjfs5wumspa2cxqsvsw8gefe823",
                amount: 5.79912864,
                timestamp: 1738065600975,
                transactionHash: "eb7373197c9cc3f94b78d8d08b9d444ccad5c8844ae332a3d061d0802f73b7bc"
            ),
            PoolPayout(
                walletAddress: "kaspa:qqt26gdaa0vp6ne8jlkxsm5yjnhywq3cc6yepq8zvnjytnh6k7cx5kdwgmqgq",
                amount: 29.41335274,
                timestamp: 1738065600975,
                transactionHash: "eb7373197c9cc3f94b78d8d08b9d444ccad5c8844ae332a3d061d0802f73b7bc"
            ),
            PoolPayout(
                walletAddress: "kaspa:qypnw3h84jzkjmdxg5qa07kxznyrex4nnk2pakvhgkdn6htl3qa57ssvmjn409p",
                amount: 6.25437828,
                timestamp: 1738065600975,
                transactionHash: "eb7373197c9cc3f94b78d8d08b9d444ccad5c8844ae332a3d061d0802f73b7bc"
            ),
            PoolPayout(
                walletAddress: "kaspa:qyp0kz62ja9wavdvyrlts0vyu54guv77x0dh4ej4m6k8s3wpxm6dmnqez9jy6lg",
                amount: 41.87942143,
                timestamp: 1738065600975,
                transactionHash: "eb7373197c9cc3f94b78d8d08b9d444ccad5c8844ae332a3d061d0802f73b7bc"
            ),
            PoolPayout(
                walletAddress: "kaspa:qyp2ag4suam7ft8un8d7096rlve40d4hlmq0f45elgrdrzqvzfj8mnslj4pyytx",
                amount: 284.22512623,
                timestamp: 1738065600975,
                transactionHash: "eb7373197c9cc3f94b78d8d08b9d444ccad5c8844ae332a3d061d0802f73b7bc"
            )
        ]
    }

    func fetchAddressTokens(address: String) async throws -> [AddressTokenInfoKasFyiDTO] {
        try await Task.sleep(nanoseconds: 2_000_000_000) // Simulates delay

        let tokens = [
            AddressTokenInfoKasFyiDTO(
                balance: "9372704713966445",
                ticker: "GHOAD",
                decimal: "8",
                locked: "0",
                opScoreMod: "1027115990000",
                price: .init(
                    floorPrice: 0.005903077422961695,
                    priceInUsd: 0.0005086584733943417,
                    marketCapInUsd: 2034633.3847697156,
                    change24h: 3.9924914428355924,
                    change24hInKas: 10.839678375030424
                ),
                iconUrl: URL(string: "https://krc20-assets.kas.fyi/icons/GHOAD.jpg")!
            ),
            AddressTokenInfoKasFyiDTO(
                balance: "64709650775759093",
                ticker: "NACHO",
                decimal: "8",
                locked: "0",
                opScoreMod: "1026817450001",
                price: .init(
                    floorPrice: 0.00045633630777855574,
                    priceInUsd: 0.00003932174915513671,
                    marketCapInUsd: 11285341.521405213,
                    change24h: -15.907294364549385,
                    change24hInKas: -10.372914115966662
                ),
                iconUrl: URL(string: "https://krc20-assets.kas.fyi/icons/NACHO.jpg")!
            ),
            AddressTokenInfoKasFyiDTO(
                balance: "135050002871078355",
                ticker: "KASPY",
                decimal: "8",
                locked: "0",
                opScoreMod: "1025218250000",
                price: .init(
                    floorPrice: 0.00016555817575224883,
                    priceInUsd: 0.000014265875729246294,
                    marketCapInUsd: 4721138.034599611,
                    change24h: -5.210128044875123,
                    change24hInKas: 1.0055370338898397
                ),
                iconUrl: URL(string: "https://krc20-assets.kas.fyi/icons/KASPY.jpg")!
            )
        ]

        return tokens
    }
}
