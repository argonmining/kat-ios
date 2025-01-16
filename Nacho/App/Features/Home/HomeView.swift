import SwiftUI

struct HomeView: View {

    @State var viewModel: HomeViewModel
    let namespace: Namespace.ID

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.padding_2) {
                HStack(spacing: Spacing.padding_1_5) {
                    Image("logo")
                        .resizable()
                        .frame(width: Size.iconMedium, height: Size.iconMedium)
                    Text("NACHO")
                        .typography(.headline3, color: .textAccent)
                    Spacer()
                    Text(Localization.homeFairMint)
                        .typography(.body1, color: .textOnSolid)
                        .padding(.vertical, Spacing.padding_0_2_5)
                        .padding(.horizontal, Spacing.padding_1)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.radius_1)
                                .fill(Color.solidSuccess)
                        )
                }
                .padding(.bottom, Spacing.padding_1)
                HStack(spacing: Spacing.padding_2) {
                    WidgetDS {
                        VStack(alignment: .leading, spacing: Spacing.padding_1) {
                            Text(Localization.homeWidgetDeployed)
                                .typography(.headline3, color: .textSecondary)
                            Text(stringDate)
                                .typography(.body1)
                                .padding(.bottom, Spacing.padding_1)
                            Text(Localization.homeWidgetSupply)
                                .typography(.headline3, color: .textSecondary)
                            Text(stringSupply)
                                .typography(.body1)
                                .padding(.bottom, Spacing.padding_1)
                            Text(Localization.homeWidgetTotalMints)
                                .typography(.headline3, color: .textSecondary)
                            Text(stringTotalMints)
                                .typography(.body1)
                                .padding(.bottom, Spacing.padding_1)
                        }
                    }
                    PriceWidgetView(viewData: $viewModel.tokenPriceData)
                }
                PriceChartWidgetView(tradeData: $viewModel.chartData)
                    .frame(height: 250)
                Spacer()
            }
            .padding(Spacing.padding_2)
        }
        .navigationTitle(Localization.homeNavigationTitle)
        .background(
            Color.surfaceBackground
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .task {
            await viewModel.fetchPriceInfo()
        }
    }

    private var stringSupply: String {
        return Formatter.formatToNumber(value: NachoInfo.maxSupply)
    }

    private var stringTotalMints: String {
        return Formatter.formatToNumber(value: NachoInfo.mintTotal)
    }

    private var stringDate: String {
        return Formatter.formatDate(value: NachoInfo.releaseTimeInterval)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(networkService: MockNetworkService()),
            namespace: namespace
        )
    }
}
