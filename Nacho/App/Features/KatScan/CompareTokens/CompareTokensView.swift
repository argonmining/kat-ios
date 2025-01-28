import SwiftUI

struct CompareTokensView: View {
    
    @State var viewModel: CompareTokensViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.padding_2) {
                tokenSelectionWidget
                if viewModel.token1 != nil && viewModel.token2 != nil && !viewModel.isLoading() {
                    tokenInfoWidget
                    priceWidget
                } else if viewModel.isLoading() {
                    loadingWidget
                }
            }
            .padding(Spacing.padding_2)
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.compareTokensTitle)
    }

    private var tokenInfoWidget: some View {
        WidgetDS {
            VStack(spacing: .zero) {
                HStack {
                    Text(Localization.holdersText)
                        .typography(.headline3, color: .textSecondary)
                    Spacer()
                }
                HStack {
                    Text(viewModel.token1Holders())
                        .typography(.numeric3)
                        .lineLimit(1)
                    Spacer()
                    Text(viewModel.token2Holders())
                        .typography(.numeric3)
                        .lineLimit(1)
                }
                .padding(.top, Spacing.padding_1)

                HStack {
                    Text(Localization.widgetSupply)
                        .typography(.headline3, color: .textSecondary)
                    Spacer()
                }
                .padding(.top, Spacing.padding_2)
                HStack {
                    Text(viewModel.token1Supply())
                        .typography(.numeric4)
                        .lineLimit(1)
                    Spacer()
                    Text(viewModel.token2Supply())
                        .typography(.numeric4)
                        .lineLimit(1)
                }
                .padding(.top, Spacing.padding_1)

                HStack {
                    Text(Localization.premintedText)
                        .typography(.headline3, color: .textSecondary)
                    Spacer()
                }
                .padding(.top, Spacing.padding_2)
                HStack {
                    if let preminted = viewModel.token1Preminted() {
                        VStack(alignment: .leading) {
                            Text(preminted.1)
                                .typography(.numeric4)
                                .lineLimit(1)
                            PillDS(
                                text: preminted.0 ? Localization.fairMint : Localization.preMint,
                                style: .medium,
                                color: preminted.0 ? .solidSuccess : .solidWarning
                            )
                        }
                    }
                    Spacer()
                    if let preminted = viewModel.token2Preminted() {
                        VStack(alignment: .trailing) {
                            Text(preminted.1)
                                .typography(.numeric4)
                                .lineLimit(1)
                            PillDS(
                                text: preminted.0 ? Localization.fairMint : Localization.preMint,
                                style: .medium,
                                color: preminted.0 ? .solidSuccess : .solidWarning
                            )
                        }
                    }
                }
                .padding(.top, Spacing.padding_1)

                HStack {
                    Text(Localization.mintedText)
                        .typography(.headline3, color: .textSecondary)
                    Spacer()
                }
                .padding(.top, Spacing.padding_2)
                HStack {
                    Text(viewModel.token1Minted())
                        .typography(.numeric4)
                        .lineLimit(1)
                    Spacer()
                    Text(viewModel.token2Minted())
                        .typography(.numeric4)
                        .lineLimit(1)
                }
                .padding(.top, Spacing.padding_1)
            }
        }
    }

    @ViewBuilder
    private var priceWidget: some View {
        if
            let tokenPriceData1 = viewModel.tokenPriceData1,
            let tokenPriceData2 = viewModel.tokenPriceData2
        {
            WidgetDS {
                VStack(spacing: .zero) {
                    HStack {
                        Text(Localization.widgetPriceTitle)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("$\(Formatter.formatToNumber(tokenPriceData1.price, decimal: 8))")
                                .typography(.numeric3)
                                .lineLimit(1)
                            PillDS(
                                text: Formatter.formatPercentage(tokenPriceData1.change, decimal: 2),
                                style: .medium,
                                color: tokenPriceData1.change >= 0 ? .solidSuccess : .solidDanger
                            )
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("$\(Formatter.formatToNumber(tokenPriceData2.price, decimal: 8))")
                                .typography(.numeric3)
                                .lineLimit(1)
                            PillDS(
                                text: Formatter.formatPercentage(tokenPriceData2.change, decimal: 2),
                                style: .medium,
                                color: tokenPriceData2.change >= 0 ? .solidSuccess : .solidDanger
                            )
                        }
                    }
                    .padding(.top, Spacing.padding_1)
                    
                    HStack {
                        Text(Localization.widgetChartTitle)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_2)
                    HStack {
                        LineChartDS(chartData: $viewModel.chartData1, showVerticalLabels: false, decimal: 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                        Spacer()
                            .frame(width: Spacing.padding_2)
                        LineChartDS(chartData: $viewModel.chartData2, showVerticalLabels: false, decimal: 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                    .padding(.top, Spacing.padding_1)
                    
                    HStack {
                        Text(Localization.widgetMCTitle)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_2)
                    HStack {
                        Text(Formatter.formatToUSD(tokenPriceData1.marketCap, decimal: 0))
                            .typography(.numeric4)
                            .lineLimit(1)
                        Spacer()
                        Text(Formatter.formatToUSD(tokenPriceData2.marketCap, decimal: 0))
                            .typography(.numeric4)
                            .lineLimit(1)
                    }
                    .padding(.top, Spacing.padding_1)
                    
                    HStack {
                        Text(Localization.widgetVolumeTitle)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_2)
                    HStack {
                        Text(Formatter.formatToUSD(tokenPriceData1.volume, decimal: 0))
                            .typography(.numeric4)
                            .lineLimit(1)
                        Spacer()
                        Text(Formatter.formatToUSD(tokenPriceData2.volume, decimal: 0))
                            .typography(.numeric4)
                            .lineLimit(1)
                    }
                    .padding(.top, Spacing.padding_1)
                }
            }
        }
    }

    private var loadingWidget: some View {
        WidgetDS {
            VStack {
                HStack {
                    Text(Localization.holdersText)
                        .typography(.headline3, color: .textSecondary)
                        .shimmer(isActive: true)
                    Spacer()
                }
                HStack {
                    Text("9999999")
                        .typography(.numeric3)
                        .lineLimit(1)
                        .shimmer(isActive: true)
                    Spacer()
                    Text("99999999999")
                        .typography(.numeric3)
                        .lineLimit(1)
                        .shimmer(isActive: true)
                }
            }
        }
    }

    private var tokenSelectionWidget: some View {
        WidgetDS {
            HStack {
                if let token1 = viewModel.token1 {
                    HStack {
                        TokenImage(token1)
                        Text(token1).typography(.body1)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        viewModel.isFirstToken = true
                        viewModel.showTokenSelection = true
                    }
                } else {
                    ButtonDS(
                        Localization.compareTokensButtonSelect1,
                        style: .contained,
                        isSmall: true
                    ) {
                        viewModel.isFirstToken = true
                        viewModel.showTokenSelection = true
                    }
                }
                Divider().frame(width: 1)
                    .padding(.horizontal, Spacing.padding_0_5)
                if let token2 = viewModel.token2 {
                    HStack {
                        Text(token2).typography(.body2)
                        TokenImage(token2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        viewModel.isFirstToken = false
                        viewModel.showTokenSelection = true
                    }
                } else {
                    ButtonDS(
                        Localization.compareTokensButtonSelect2,
                        style: .contained,
                        isSmall: true
                    ) {
                        viewModel.isFirstToken = false
                        viewModel.showTokenSelection = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.showTokenSelection) {
                    NavigationView {
                        TokenSelectionView(
                            tokens: viewModel.tokens,
                            selectedToken: viewModel.isFirstToken ? viewModel.token1 : viewModel.token2
                        ) { token in
                            if viewModel.isFirstToken {
                                viewModel.token1 = token
                            } else {
                                viewModel.token2 = token
                            }
                            viewModel.showTokenSelection = false
                            viewModel.onTokensUpdated()
                        }
                    }
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    NavigationView {
        CompareTokensView(
            viewModel: CompareTokensViewModel(
                tokensInfo: [
                    TokenDeployInfo(
                        tick: "NACHO",
                        maxSupply: 287000000,
                        limit: 2870000,
                        preMinted: 0,
                        minted: 287000000,
                        holdersTotal: 17752,
                        mintTotal: 9998095,
                        logoPath: "/logos/NACHO.jpg",
                        releaseTimeInterval: 1737025209359
                    ),
                    TokenDeployInfo(
                        tick: "KDAO",
                        maxSupply: 150000000,
                        limit: 10000000,
                        preMinted: 0,
                        minted: 150000000,
                        holdersTotal: 8691,
                        mintTotal: 14975122,
                        logoPath: "/logos/KDAO.jpg",
                        releaseTimeInterval: 1737025209359
                    ),
                    TokenDeployInfo(
                        tick: "KASPER",
                        maxSupply: 28700000,
                        limit: 2870000,
                        preMinted: 0,
                        minted: 28700000,
                        holdersTotal: 7113,
                        mintTotal: 999614,
                        logoPath: "/logos/KASPER.jpg",
                        releaseTimeInterval: 1737025209359
                    ),
                    TokenDeployInfo(
                        tick: "GHOAD",
                        maxSupply: 4000000,
                        limit: 7680000,
                        preMinted: 2800000,
                        minted: 4000000,
                        holdersTotal: 6923,
                        mintTotal: 156250,
                        logoPath: "/logos/GHOAD.jpg",
                        releaseTimeInterval: 1737025209359
                    )
                ],
                networkService: MockNetworkService()
            )
        )
    }
}
