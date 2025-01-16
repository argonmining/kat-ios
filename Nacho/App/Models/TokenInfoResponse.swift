import Foundation

struct TokenPriceData {

    let ticker: String
    let price: Double
    let marketCap: Double
    let volume: Double
    let change: Double

    init(fromTokenInfoResponse response: TokenInfoResponse) {
        self.ticker = response.ticker
        self.price = response.price.priceInUsd
        self.marketCap = response.price.marketCapInUsd
        self.volume = response.tradeVolume.amountInUsd
        self.change = response.price.change24h
    }
}

struct TokenInfoResponse: Decodable {
    let ticker: String
    let holderTotal: UInt32
    let transferTotal: UInt64
    let price: Price
    let tradeVolume: TradeVolume
}

extension TokenInfoResponse {

    struct Price: Decodable {
        let priceInUsd: Double
        let marketCapInUsd: Double
        let change24h: Double
    }

    struct TradeVolume: Decodable {
        let amountInUsd: Double
    }
}
