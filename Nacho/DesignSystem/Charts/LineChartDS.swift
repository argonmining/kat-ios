import SwiftUI
import Charts

struct LineChartDS: View {
    
    @Binding var chartData: [ChartData]?
    let showVerticalLabels: Bool
    let decimal: Int
    @State private var minValue: Double = 0
    @State private var maxValue: Double = 0
    @State private var delta: Double = 0
    @State private var timeInterval: TimeInterval = 0
    
    var body: some View {
        Group {
            if let tradeData = chartData {
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
                        if let date = value.as(Date.self) {
                            AxisValueLabel(format: xAxisFormat(for: date))
                        }
                        AxisTick()
                        AxisGridLine()
                    }
                }
                .chartYAxis {
                    if showVerticalLabels {
                        AxisMarks(values: .automatic) { value in
                            if let priceValue = value.as(Double.self) {
                                AxisValueLabel {
                                    Text(String(format: "%.\(decimal)f", priceValue))
                                }
                            }
                            AxisTick()
                            AxisGridLine()
                        }
                    }
                }
                .chartYScale(domain: minValue - delta...maxValue + delta)
            } else {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            calculateBounds()
        }
        .onChange(of: chartData) { _, _ in
            calculateBounds()
        }
    }
    
    private func calculateBounds() {
        guard let chartData else { return }
        minValue = chartData.min(by: { $0.value < $1.value })?.value ?? 0
        maxValue = chartData.max(by: { $0.value < $1.value })?.value ?? 0
        delta = (maxValue - minValue) / 3
        
        if let first = chartData.first, let last = chartData.last {
            timeInterval = last.timestamp - first.timestamp
        }
    }
    
    private func xAxisFormat(for date: Date) -> Date.FormatStyle {
        if timeInterval < 86_400 { // Less than 1 day (24 hours * 60 * 60)
            return .dateTime.hour().minute()
        } else if timeInterval < 7 * 86_400 { // Less than 1 week
            return .dateTime.weekday()
        } else { // More than a week
            return .dateTime.day().month().year()
        }
    }
}

extension LineChartDS {
    
    struct ChartData: Identifiable, Hashable {
        let id: UUID
        let timestamp: Double
        let value: Double
    }
}

#Preview {
    LineChartDS(chartData: .constant([
        LineChartDS.ChartData(id: UUID(), timestamp: 1673500000, value: 0.00008575),
        LineChartDS.ChartData(id: UUID(), timestamp: 1673503600, value: 0.00008629),
        LineChartDS.ChartData(id: UUID(), timestamp: 1673507200, value: 0.00008757),
        LineChartDS.ChartData(id: UUID(), timestamp: 1673510800, value: 0.00008739)
    ]), showVerticalLabels: true, decimal: 8)
}
