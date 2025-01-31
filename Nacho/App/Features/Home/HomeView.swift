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
                    PillDS(text: Localization.fairMint, style: .large)
                }
                .padding(.bottom, Spacing.padding_1)
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
                    PriceWidgetView(viewData: $viewModel.tokenPriceData)
                }

                PriceChartWidgetView(chartData: $viewModel.chartData)

                if viewModel.showHolders {
                    WidgetDS {
                        TopHoldersView(
                            holders: $viewModel.holders,
                            supply: NachoInfo.maxSupply
                        )
                    }

                }

                Spacer()
            }
            .padding(Spacing.padding_2)
        }
        .navigationTitle(Localization.homeNavigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
//                    viewModel.showFilter.toggle()
                }) {
                    Image(
                        systemName: "wallet.bifold.fill"
                    )
                    .fontWeight(.medium)
                }
            }
        }
        .background(
            Color.surfaceBackground
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .task {
            await viewModel.fetchPriceInfo()
            await viewModel.fetchTokenHolders()
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
            viewModel: HomeViewModel(networkService: MockNetworkService()),
            namespace: namespace
        )
    }
}
