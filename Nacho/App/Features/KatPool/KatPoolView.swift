import SwiftUI

struct KatPoolView: View {

    @State var viewModel: KatPoolViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.padding_2) {
                if viewModel.isLoading {
                    loadingPlaceholder
                } else {
                    if
                        let blocks = viewModel.blocks,
                        let blocks24h = viewModel.blocks24h,
                        let minersChartData = viewModel.minersChartData,
                        let minersCount = viewModel.minersCount
                    {
                        HStack(spacing: Spacing.padding_2) {
                            smallWidget(
                                title: Localization.katPoolBlocks,
                                value: Formatter.formatToNumber(blocks)
                            )
                            smallWidget(
                                title: Localization.katPoolBlocks24h,
                                value: Formatter.formatToNumber(blocks24h)
                            )
                        }

                        WidgetDS {
                            VStack(spacing: Spacing.padding_1) {
                                HStack {
                                    Text("\(Formatter.formatToNumber(minersCount)) " + Localization.katPoolMinersTitle)
                                        .typography(.headline3, color: .textSecondary)
                                    Spacer()
                                }
                                HStack {
                                    VStack(alignment: .leading) {
                                        ForEach(minersChartData, id: \.self) { data in
                                            HStack {
                                                Circle().foregroundStyle(data.color)
                                                    .frame(width: 12)
                                                Text(data.label)
                                                    .typography(.body1)
                                                Text(Formatter.formatPercentage(data.percentage * 100))
                                                    .typography(.body1, color: .textSecondary)
                                                Spacer()
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    Spacer()
                                    Divider()
                                    Spacer()
                                    DonutChartDS(chartData: minersChartData)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }

                        WidgetDS {
                            VStack {
                                HStack {
                                    Text(Localization.katPoolHashrateTitle)
                                        .typography(.headline3, color: .textSecondary)
                                    Spacer()
                                    Picker("Time Period", selection: $viewModel.hashrateTimeInterval) {
                                        Text("7d").tag(7)
                                        Text("30d").tag(30)
                                        Text("3m").tag(90)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(width: 140)
                                    .onChange(of: viewModel.hashrateTimeInterval) { _, newValue in
                                        Task {
                                            await viewModel.fetchHashrateData()
                                        }
                                    }
                                }
                                LineChartDS(
                                    chartData: $viewModel.hashrateChartData,
                                    showVerticalLabels: true,
                                    decimal: 0
                                )
                                .frame(height: 200)
                            }
                        }
                    } else {
                        EmptyStateDS(text: Localization.emptyViewText)
                            .padding(.top, Spacing.padding_10)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding(Spacing.padding_2)
        }
        .navigationTitle(Localization.katPoolTitle)
        .background(Color.surfaceBackground.ignoresSafeArea())
        .task {
            await viewModel.fetchBlocksInfo()
        }
    }

    private func smallWidget(title: String, value: String) -> some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1) {
                HStack {
                    Text(title)
                        .typography(.headline3, color: .textSecondary)
                        .lineLimit(1)
                    Spacer()
                }
                Text(value)
                    .typography(.numeric3)
            }
        }
    }

    private var loadingPlaceholder: some View {
        HStack(spacing: Spacing.padding_2) {
            loadingWidget
            loadingWidget
        }
    }

    private var loadingWidget: some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1) {
                HStack {
                    Text("Title1")
                        .typography(.headline3, color: .textSecondary)
                        .shimmer(isActive: true)
                    Spacer()
                }
                Text("Value1")
                    .typography(.numeric3)
                    .shimmer(isActive: true)
            }
        }
    }
}

#Preview {
    NavigationView {
        KatPoolView(viewModel: .init(networkService: MockNetworkService()))
    }
}
