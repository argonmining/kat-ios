import SwiftUI
import Charts

struct DonutChartDS: View {

    @State var chartData: [ChartData]?

    var body: some View {
        if let chartData {
            Chart(chartData) { data in
                SectorMark(
                    angle: .value("Percentage", data.percentage),
                    innerRadius: .ratio(0.6),
                    angularInset: 3
                )
                .foregroundStyle(data.color)
                .cornerRadius(Radius.radius_0_5)
            }
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
}

extension DonutChartDS {

    struct ChartData: Identifiable, Hashable {
        let id: Int
        let label: String
        let value: Double
        let percentage: Double
        let color: Color
    }
}

#Preview {
    DonutChartDS(chartData: [
        .init(id: 0, label: "Data1", value: 20, percentage: 10, color: .surfaceAccent),
        .init(id: 1, label: "Data1", value: 30, percentage: 20, color: .solidSuccess),
        .init(id: 2, label: "Data1", value: 50, percentage: 30, color: .solidWarning)
    ])
    .frame(height: 300)
    .padding()
}
