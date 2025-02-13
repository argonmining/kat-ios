import SwiftUI

struct HomeView: View {

    @State var viewModel: HomeViewModel
    let namespace: Namespace.ID

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                if viewModel.showAddresses {
                    addressesWidget
                        .padding(.bottom, Spacing.padding_2)
                        .sheet(isPresented: $viewModel.addressTokensViewPresented) {
                            if
                                let address = viewModel.selectedAddress,
                                let tokens = viewModel.addressTokens[address]
                            {
                                NavigationView {
                                    AddressTokensView(address: address, tokens: tokens)
                                }
                                .presentationDetents([.large])
                                .presentationDragIndicator(.visible)
                            } else {
                                EmptyView()
                            }
                        }
                        .shimmer(isActive: viewModel.addressesLoading)
                }

                HStack(spacing: Spacing.padding_1_5) {
                    Image("logo")
                        .resizable()
                        .frame(width: Size.iconMedium, height: Size.iconMedium)
                    Text("NACHO")
                        .typography(.headline3, color: .textAccent)
                    Spacer()
                    PillDS(text: Localization.fairMint, style: .large)
                }
                .padding(.horizontal, Spacing.padding_2)
                .padding(.bottom, Spacing.padding_2)

                HStack(spacing: Spacing.padding_2) {
                    WidgetDS {
                        VStack(alignment: .leading, spacing: Spacing.padding_1) {
                            Text(Localization.widgetDeployed)
                                .typography(.headline3, color: .textSecondary)
                            Text(dateString)
                                .typography(.body1)
                                .padding(.bottom, Spacing.padding_1)
                            Text(Localization.widgetSupply)
                                .typography(.headline3, color: .textSecondary)
                            Text(supplyString)
                                .typography(.body1)
                                .padding(.bottom, Spacing.padding_1)
                            Text(Localization.widgetTotalMints)
                                .typography(.headline3, color: .textSecondary)
                            Text(totalMintsString)
                                .typography(.body1)
                                .padding(.bottom, Spacing.padding_1)
                        }
                    }
                    .shimmer(isActive: viewModel.isLoading)

                    PriceWidgetView(viewData: $viewModel.tokenPriceData)
                        .shimmer(isActive: viewModel.isLoading)
                }
                .padding(.horizontal, Spacing.padding_2)
                .padding(.bottom, Spacing.padding_2)

                PriceChartWidgetView(chartData: $viewModel.chartData)
                    .shimmer(isActive: viewModel.isLoading)
                    .padding(.horizontal, Spacing.padding_2)
                    .padding(.bottom, Spacing.padding_2)

                if viewModel.showHolders {
                    WidgetDS {
                        TopHoldersView(
                            holders: $viewModel.holders,
                            supply: NachoInfo.maxSupply
                        )
                    }
                    .padding(.horizontal, Spacing.padding_2)
                }

                Spacer()
            }
            .padding(.bottom, Spacing.padding_2)
        }
        .navigationTitle(Localization.homeNavigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.walletPresented = true
                }) {
                    Image("wallet")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                }
                .fullScreenCover(isPresented: $viewModel.walletPresented) {
                    NavigationView {
                        WalletsView(viewModel: .init(dataProvider: viewModel.dataProvider))
                    }
                    .onDisappear {
                        viewModel.checkAddresses()
                    }
                }
            }
        }
        .background(
            Color.surfaceBackground
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .refreshable {
            viewModel.refresh()
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
            .frame(height: 160)
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
                                let tokens = viewModel.addressTokens[addressModel.address]
                            {
                                HStack {
                                    Text("\(tokens.count) tokens")
                                        .typography(.body1)
                                    Spacer()
                                    Text(Formatter.formatToUSD(tokens.reduce(0.0) { total, token in
                                        total + (token.price?.priceInUsd ?? 0.0) * token.calculatedBalance
                                    }))
                                    .typography(.numeric4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.padding_2)
                    .onTapGesture {
                        viewModel.selectedAddress = addressModel.address
                        viewModel.addressTokensViewPresented = true
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 160)
        }
    }

    private var supplyString: String {
        Formatter.formatToNumber(NachoInfo.maxSupply)
    }

    private var totalMintsString: String {
        Formatter.formatToNumber(NachoInfo.mintTotal)
    }

    private var dateString: String {
        Formatter.formatDate(NachoInfo.releaseTimeInterval)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                networkService: MockNetworkService(),
                dataProvider: MockDataProvider()
            ),
            namespace: namespace
        )
    }
}
