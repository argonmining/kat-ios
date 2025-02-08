import Foundation

struct AddressTokenInfoKasFyiDTO: Decodable, Hashable {

    let balance: String
    let ticker: String
    let decimal: String
    let locked: String
    let opScoreMod: String
    let price: Price?
    let iconUrl: URL

    init(
        balance: String,
        ticker: String,
        decimal: String,
        locked: String,
        opScoreMod: String,
        price: Price,
        iconUrl: URL
    ) {
        self.balance = balance
        self.ticker = ticker
        self.decimal = decimal
        self.locked = locked
        self.opScoreMod = opScoreMod
        self.price = price
        self.iconUrl = iconUrl
    }

    var calculatedBalance: Double {
        guard let balanceValue = Double(balance),
              let decimalValue = Int(decimal) else {
            return 0.0
        }
        return balanceValue / pow(10.0, Double(decimalValue))
    }

    struct Price: Decodable {
        let floorPrice: Double
        let priceInUsd: Double
        let marketCapInUsd: Double
        let change24h: Double
        let change24hInKas: Double
    }

    static func ==(lhs: AddressTokenInfoKasFyiDTO, rhs: AddressTokenInfoKasFyiDTO) -> Bool {
        return lhs.balance == rhs.balance &&
               lhs.ticker == rhs.ticker &&
               lhs.decimal == rhs.decimal &&
               lhs.locked == rhs.locked &&
               lhs.opScoreMod == rhs.opScoreMod &&
               lhs.iconUrl == rhs.iconUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(balance)
        hasher.combine(ticker)
        hasher.combine(decimal)
        hasher.combine(locked)
        hasher.combine(opScoreMod)
        hasher.combine(iconUrl)
    }
}
