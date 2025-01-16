import Foundation

struct TokenChartResponse: Decodable {
    let candles: [ChartTradeItem]
}
