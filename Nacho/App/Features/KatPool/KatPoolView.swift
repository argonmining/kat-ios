import SwiftUI

struct KatPoolView: View {

    @State var viewModel: KatPoolViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                if viewModel.showAddresses {
                    addressesWidget
                        .padding(.bottom, Spacing.padding_2)
                        .sheet(isPresented: $viewModel.addressWorkersViewPresented) {
                            if let viewModel = viewModel.addressWorkersViewModel {
                                NavigationView {
                                    AddressWorkersView(viewModel: viewModel)
                                }
                                .presentationDetents([.large])
                                .presentationDragIndicator(.visible)
                            } else {
                                EmptyView()
                            }
                        }
                }
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
                        .padding(.bottom, Spacing.padding_2)

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
                        .padding(.bottom, Spacing.padding_2)
                        hashrateWidget
                            .padding(.bottom, Spacing.padding_2)
                        payoutsWidget
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
        .onAppear {
            viewModel.checkAddresses()
        }
    }

    @ViewBuilder
    private var addressesWidget: some View {
        if viewModel.addressesLoading {
            TabView {
                WidgetDS {
                    VStack(alignment: .leading, spacing: Spacing.padding_1) {
                        PillDS(
                            text: "addressaddress",
                            style: .large,
                            color: .accentColor.opacity(0.7)
                        )
                        .shimmer(isActive: true)
                        HStack {
                            Text("0 tokens")
                                .typography(.body1)
                                .shimmer(isActive: true)
                            Spacer()
                            Text("0.00")
                            .typography(.numeric4)
                            .shimmer(isActive: true)
                        }
                    }
                }
                .padding(.horizontal, Spacing.padding_2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 86)
        } else {
            TabView {
                ForEach(viewModel.addressModels, id: \.self) { addressModel in
                    WidgetDS {
                        VStack(alignment: .leading, spacing: Spacing.padding_1) {
                            PillDS(
                                text: addressModel.address.trimmedInMiddle(toLength: 22, shiftStartBy: 6),
                                style: .large,
                                color: .accentColor.opacity(0.7)
                            )
                            if
                                let workers = viewModel.addressWorkers[addressModel.address]
                            {
                                HStack {
                                    Text("\(workers.count) workers")
                                        .typography(.body1)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.padding_2)
                    .onTapGesture {
                        viewModel.selectAddress(addressModel.address)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 86)
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
    }

    private var payoutsWidget: some View {
        WidgetDS {
            VStack {
                HStack {
                    Text(Localization.katPoolPayoutsTitle)
                        .typography(.headline3, color: .textSecondary)
                    Spacer()
                    Picker("Time Period", selection: $viewModel.payoutsTimeInterval) {
                        Text("7d").tag(7)
                        Text("30d").tag(30)
                        Text("3m").tag(90)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 140)
                    .onChange(of: viewModel.payoutsTimeInterval) { _, newValue in
                        Task {
                            await viewModel.fetchPayoutData()
                        }
                    }
                }
                LineChartDS(
                    chartData: $viewModel.payoutChartData,
                    showVerticalLabels: true,
                    decimal: 0
                )
                .frame(height: 200)
                if let latestPayouts = viewModel.latestPayouts {
                    HStack {
                        Text(Localization.katPoolRecentPayoutsTitle)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_2)
                    VStack(spacing: Spacing.padding_2) {
                        ForEach(latestPayouts, id: \.self) { payout in
                            VStack(spacing: Spacing.padding_1) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        PillDS(
                                            text: payout.walletAddress.trimmedInMiddle(toLength: 11, shiftStartBy: 6),
                                            style: .medium,
                                            color: .accentColor.opacity(0.7)
                                        )
                                        .onTapGesture {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            UIPasteboard.general.string = payout.walletAddress
                                            Notifications.presentTopMessage(Localization.addressCopyMessage)
                                        }
                                        Text(Formatter.formatDateAndTime(payout.timestamp / 1000))
                                            .typography(.caption)
                                    }
                                    Spacer()
                                    Text(Formatter.formatToNumber(payout.amount) + " KAS")
                                        .typography(.body1, color: .solidSuccess)
                                }
                                Divider()
                            }
                        }
                    }
                }
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
        KatPoolView(
            viewModel: .init(
                networkService: MockNetworkService(),
                dataProvider: MockDataProvider()
            )
        )
    }
}
