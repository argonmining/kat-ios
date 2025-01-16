import SwiftUI
import Charts

struct PriceChartWidgetView: View {

    @Binding var tradeData: [ChartTradeItem]?
    @State private var minValue: Double = 0
    @State private var maxValue: Double = 0
    @State private var delta: Double = 0

    var body: some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1) {
                Text(Localization.widgetChartTitle)
                    .typography(.headline3, color: .textSecondary)
                // Chart
                if let tradeData = tradeData {
                    Chart(tradeData) { item in
                        AreaMark(
                            x: .value("Time", Date(timeIntervalSince1970: item.timestamp)),
                            yStart: .value("Price", item.value),
                            yEnd: .value("PriceEnd", minValue)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.solidInfo.opacity(0.3),
                                    Color.solidInfo.opacity(0.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        LineMark(
                            x: .value("Time", Date(timeIntervalSince1970: item.timestamp)),
                            y: .value("Price", item.value)
                        )
                        .foregroundStyle(.solidInfo)
                        .lineStyle(.init(lineWidth: 2))
                        .interpolationMethod(.catmullRom)
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            if value.as(Date.self) != nil {
                                AxisValueLabel(format: .dateTime.hour().minute())
                            }
                            AxisTick()
                            AxisGridLine()
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: .automatic) { value in
                            if let priceValue = value.as(Double.self) {
                                AxisValueLabel {
                                    Text(String(format: "%.8f", priceValue))
                                }
                            }
                            AxisTick()
                            AxisGridLine()
                        }
                    }
                    .chartYScale(domain: minValue-delta...maxValue+delta)
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: tradeData) { _, newValue in
            guard let newValue else { return }
            minValue = newValue.min(by: { $0.value < $1.value })?.value ?? 0
            maxValue = newValue.max(by: { $0.value < $1.value })?.value ?? 0
            delta = (maxValue - minValue) / 3
        }
    }
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            PriceChartWidgetView(
                tradeData: .constant([
                    ChartTradeItem(timestamp: 1673500000, value: 0.00008575),
                    ChartTradeItem(timestamp: 1673503600, value: 0.00008629),
                    ChartTradeItem(timestamp: 1673507200, value: 0.00008757),
                    ChartTradeItem(timestamp: 1673510800, value: 0.00008739)
                ])
            )
            .frame(height: 250)
            Spacer()
        }
        Spacer()
    }
    .padding()
    .background(Color.surfaceBackground.ignoresSafeArea())
}
