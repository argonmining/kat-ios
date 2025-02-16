import SwiftUI

struct AddressWorkersView: View {
    
    @State var viewModel: AddressWorkersViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                TabView {
                    ForEach(viewModel.workers, id: \.self) { worker in
                        WidgetDS {
                            VStack(spacing: Spacing.padding_2) {
                                HStack {
                                    Text(worker.minerID)
                                        .typography(.headline3)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                HStack {
                                    Text("15min Hashrate")
                                        .typography(.subtitle, color: .textSecondary)
                                    Spacer()
                                    Text("\(Formatter.formatToNumber(worker.fifteenMin / 1000, decimal: 3)) TH/s")
                                        .typography(.numeric4)
                                }
                                Divider()
                                HStack {
                                    Text("1H Hashrate")
                                        .typography(.subtitle, color: .textSecondary)
                                    Spacer()
                                    Text("\(Formatter.formatToNumber(worker.oneHour / 1000, decimal: 3)) TH/s")
                                        .typography(.numeric4)
                                }
                                Divider()
                                HStack {
                                    Text("12H Hashrate")
                                        .typography(.subtitle, color: .textSecondary)
                                    Spacer()
                                    Text("\(Formatter.formatToNumber(worker.twelveHour / 1000, decimal: 3)) TH/s")
                                        .typography(.numeric4)
                                }
                                Divider()
                                HStack {
                                    Text("24H Hashrate")
                                        .typography(.subtitle, color: .textSecondary)
                                    Spacer()
                                    Text("\(Formatter.formatToNumber(worker.twentyFourHour / 1000, decimal: 3)) TH/s")
                                        .typography(.numeric4)
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.padding_2)
                    }
                }
                .frame(height: 320)
                .tabViewStyle(.page(indexDisplayMode: .always))

                hashrateWidget
                    .padding(.horizontal, Spacing.padding_2)

                payoutsWidget
                    .padding(Spacing.padding_2)
            }
            .padding(.bottom, Spacing.padding_2)
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle("Workers")
        .onAppear {
            Task {
                await viewModel.fetchInfo()
            }
        }
    }

    private var hashrateWidget: some View {
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
                            await viewModel.fetchInfo()
                        }
                    }
                }
                LineChartDS(
                    chartData: $viewModel.hashrateChartData,
                    showVerticalLabels: true,
                    decimal: 1
                )
                .frame(height: 200)
            }
        }
    }

    @ViewBuilder
    private var payoutsWidget: some View {
        if let payouts = viewModel.payouts {
            WidgetDS {
                LazyVStack(spacing: Spacing.padding_2) {
                    HStack {
                        Text(Localization.katPoolPayoutsTitle)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                        Text(Formatter.formatToNumber(payouts.reduce(0, { $0 + $1.amount })) + " KAS")
                            .typography(.subtitle, color: .solidSuccess)
                    }
                    ForEach(payouts, id: \.self) { payout in
                        HStack {
                            Text(Formatter.formatDateAndTime(payout.timestamp / 1000))
                                .typography(.caption)
                            Spacer()
                            Text(Formatter.formatToNumber(payout.amount) + " KAS")
                                .typography(.body1, color: .solidSuccess)
                        }
                        Divider()
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NavigationView {
        AddressWorkersView(
            viewModel: .init(
                address: "kaspa:qpddrclq2hwkacgxurz9ms4xrqjyte08megnh9qqqcudxu53kkp676y405gmn",
                workers: [
                    WorkerHashRateDTO(
                        minerID: "KS0Ultra",
                        address: "kaspa:qpddrclq2hwkacgxurz9ms4xrqjyte08megnh9qqqcudxu53kkp676y405gmn",
                        fifteenMin: 419.41247548155957,
                        oneHour: 396.02959555094907,
                        twelveHour: 414.95647986004377,
                        twentyFourHour: 413.3428633096107
                    ),
                    WorkerHashRateDTO(
                        minerID: "KS5Lrev025",
                        address: "kaspa:qpddrclq2hwkacgxurz9ms4xrqjyte08megnh9qqqcudxu53kkp676y405gmn",
                        fifteenMin: 12852.899766801804,
                        oneHour: 11730.043105685956,
                        twelveHour: 10328.460779845685,
                        twentyFourHour: 10373.292232745018
                    )
                ],
                networkService: MockNetworkService()
            )
        )
    }
}
