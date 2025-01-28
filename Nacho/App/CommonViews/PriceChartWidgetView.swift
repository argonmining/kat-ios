import SwiftUI
import Charts

struct PriceChartWidgetView: View {

    @Binding var chartData: [LineChartDS.ChartData]?
    @State private var minValue: Double = 0
    @State private var maxValue: Double = 0
    @State private var delta: Double = 0

    var body: some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1) {
                Text(Localization.widgetChartTitle)
                    .typography(.headline3, color: .textSecondary)
                LineChartDS(chartData: $chartData, showVerticalLabels: true, decimal: 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            PriceChartWidgetView(
                chartData: .constant([
                    LineChartDS.ChartData(id: UUID(), timestamp: 1673500000, value: 0.00008575),
                    LineChartDS.ChartData(id: UUID(), timestamp: 1673503600, value: 0.00008629),
                    LineChartDS.ChartData(id: UUID(), timestamp: 1673507200, value: 0.00008757),
                    LineChartDS.ChartData(id: UUID(), timestamp: 1673510800, value: 0.00008739)
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
