import SwiftUI

struct TokenDetailsView: View {

    @State var viewModel: TokenDetailsViewModel

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.padding_2) {
                        content
                    }
                    .padding(Spacing.padding_2)
                }

//                VStack {
//                    Spacer()
//                    tradeButton
//                        .padding(.horizontal, Spacing.padding_2)
//                        .padding(.top, Spacing.padding_2)
//                        .padding(.bottom, Spacing.padding_5)
//                        .background(Color.surfaceForeground)
//                }
//                .frame(maxWidth: .infinity)
//                .ignoresSafeArea(edges: .bottom)
            }
            .navigationTitle(viewModel.tokenInfo.tick)
            .background(Color.surfaceForeground.ignoresSafeArea())
            .task {
                await viewModel.fetchPriceInfo()
                await viewModel.fetchTokenHolders()
            }
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.padding_2) {

            HStack(spacing: Spacing.padding_1_5) {
                TokenImage(viewModel.tokenInfo.tick)
                Spacer()
                launchPill
            }

            if viewModel.showTradeInfo {
                HStack(spacing: Spacing.padding_1) {
                    Spacer()
                    Text("$\(priceString)")
                        .typography(.numeric)
                        .lineLimit(1)
                        .shimmer(isActive: viewModel.tokenPriceData == nil)
                    PillDS(text: changeString, style: .large, color: changeColor)
                        .shimmer(isActive: viewModel.tokenPriceData == nil)
                }
                LineChartDS(chartData: $viewModel.chartData, showVerticalLabels: true, decimal: 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .padding(.bottom, Spacing.padding_1)
                HStack {
                    Text(Localization.widgetMCTitle + ":")
                        .typography(.body1, color: .textSecondary)
                    Spacer()
                    Text(marketCapString)
                        .typography(.body1)
                        .lineLimit(1)
                        .shimmer(isActive: viewModel.tokenPriceData == nil)
                }
                HStack {
                    Text(Localization.widgetVolumeTitle + ":")
                        .typography(.body1, color: .textSecondary)
                    Spacer()
                    Text(volumeString)
                        .typography(.body1)
                        .lineLimit(1)
                        .shimmer(isActive: viewModel.tokenPriceData == nil)
                }
            }

            Text(Localization.mintProgressText)
                .typography(.headline3, color: .textSecondary)
                .padding(.top, Spacing.padding_1)

            segmentedBar

            HStack(alignment: .bottom) {
                Text(Localization.widgetDeployed + ":")
                    .typography(.body1, color: .textSecondary)
                Spacer()
                Text(deployDateString)
                    .typography(.body1)
                    .lineLimit(1)
            }
            HStack(alignment: .bottom) {
                Text(Localization.premintedText + ":")
                    .typography(.body1, color: .textSecondary)
                Spacer()
                Text(premintedString)
                    .typography(.body1)
                    .lineLimit(1)
            }
            HStack(alignment: .bottom) {
                Text(Localization.mintedText + ":")
                    .typography(.body1, color: .textSecondary)
                Spacer()
                Text(mintedString + " / " + supplyString)
                    .typography(.body1)
                    .lineLimit(1)
            }
            HStack {
                Text(Localization.holdersText + ":")
                    .typography(.body1, color: .textSecondary)
                Spacer()
                Text(holdersString)
                    .typography(.body1)
                    .lineLimit(1)
            }

            if viewModel.showHolders {
                TopHoldersView(
                    holders: $viewModel.holders,
                    supply: viewModel.tokenInfo.maxSupply
                )
                .padding(.top, Spacing.padding_1)
                .padding(.bottom, Spacing.padding_10)
            }
        }
    }

    private var tradeButton: some View {
        ButtonDS(
            Localization.tradeText,
            style: .contained,
            isSmall: true,
            icon: .leading(
                Image(systemName: "arrow.left.arrow.right")
            )
        ) {
            // TODO: Implement redirect to KSPR Bot
        }
    }

    private var launchPill: some View {
        if viewModel.tokenInfo.preMinted > 0 {
            PillDS(text: Localization.preMint, style: .large, color: .solidWarning)
        } else {
            PillDS(text: Localization.fairMint, style: .medium)
        }
    }

    private var segmentedBar: some View {
        SegmentedBarDS(segments: [
            .init(
                value: viewModel.tokenInfo.preMinted,
                color: .solidWarning
            ),
            .init(
                value: viewModel.tokenInfo.minted,
                color: .solidSuccess
            ),
            .init(
                value: viewModel.tokenInfo.maxSupply - (viewModel.tokenInfo.minted + viewModel.tokenInfo.preMinted),
                color: .textSecondary
            )
        ])
        .frame(height: 8)
    }

    private var priceString: String {
        String(format: "%.8f", viewModel.tokenPriceData?.price ?? 0)
    }

    private var marketCapString: String {
        Formatter.formatToUSD(viewModel.tokenPriceData?.marketCap ?? 0)
    }

    private var changeString: String {
        Formatter.formatPercentage(viewModel.tokenPriceData?.change ?? 0)
    }

    private var volumeString: String {
        return Formatter.formatToUSD(viewModel.tokenPriceData?.volume ?? 0)
    }

    private var premintedString: String {
        Formatter.formatToNumber(viewModel.tokenInfo.preMinted)
    }

    private var mintedString: String {
        Formatter.formatToNumber(viewModel.tokenInfo.minted + viewModel.tokenInfo.preMinted)
    }

    private var supplyString: String {
        Formatter.formatToNumber(viewModel.tokenInfo.maxSupply)
    }

    private var holdersString: String {
        Formatter.formatToNumber(viewModel.tokenInfo.holdersTotal)
    }

    private var deployDateString: String {
        Formatter.formatDateAndTime(NachoInfo.releaseTimeInterval)
    }

    private var changeColor: Color {
        viewModel.tokenPriceData?.change ?? 0 >= 0 ? .solidSuccess : .solidDanger
    }
}

#Preview {
    TokenDetailsView(viewModel: .init(tokenInfo: .init(
        tick: "NACHO",
        maxSupply: 287000000,
        limit: 2870000,
        preMinted: 0,
        minted: 287000000,
        holdersTotal: 17752,
        mintTotal: 9998095,
        logoPath: "/logos/NACHO.jpg",
        releaseTimeInterval: 1737025209359
    ), networkService: MockNetworkService()))
}
