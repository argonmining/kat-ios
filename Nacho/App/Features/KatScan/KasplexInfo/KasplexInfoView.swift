import SwiftUI

struct KasplexInfoView: View {

    @State var viewModel: KasplexInfoViewModel

    var body: some View {
        ScrollView {
            VStack {
                if let kasplexInfo = viewModel.kasplexInfo, !viewModel.isLoading {
                    WidgetDS {
                        VStack(alignment: .leading, spacing: .zero) {
                            Text(Localization.kasplexInfoTokensDeployed)
                                .typography(.headline3, color: .textSecondary)
                            Text(Formatter.formatToNumber(kasplexInfo.tokenTotal))
                                .typography(.numeric3)
                                .lineLimit(1)
                                .padding(.top, Spacing.padding_1)
                            
                            Text(Localization.kasplexInfoTotalTransactions)
                                .typography(.headline3, color: .textSecondary)
                                .padding(.top, Spacing.padding_2)
                            Text(Formatter.formatToNumber(kasplexInfo.opTotal))
                                .typography(.numeric3)
                                .lineLimit(1)
                                .padding(.top, Spacing.padding_1)

                            Text(Localization.kasplexInfoFeesPaid)
                                .typography(.headline3, color: .textSecondary)
                                .padding(.top, Spacing.padding_2)
                            Text(Formatter.formatToNumber(kasplexInfo.feeTotal) + " KAS")
                                .typography(.numeric3)
                                .lineLimit(1)
                                .padding(.top, Spacing.padding_1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else if viewModel.isLoading || viewModel.showPlaceholder == false {
                    WidgetDS {
                        VStack(alignment: .leading, spacing: .zero) {
                            Text(Localization.kasplexInfoTokensDeployed)
                                .typography(.headline3, color: .textSecondary)
                                .shimmer(isActive: true)
                            Text("999999")
                                .typography(.numeric3)
                                .lineLimit(1)
                                .padding(.top, Spacing.padding_1)
                                .shimmer(isActive: true)
                            
                            Text(Localization.kasplexInfoTotalTransactions)
                                .typography(.headline3, color: .textSecondary)
                                .shimmer(isActive: true)
                                .padding(.top, Spacing.padding_2)
                            Text("999999999999999")
                                .typography(.numeric3)
                                .shimmer(isActive: true)
                                .lineLimit(1)
                                .padding(.top, Spacing.padding_1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    EmptyStateDS(text: Localization.emptyViewText)
                        .padding(.top, Spacing.padding_10)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(Spacing.padding_2)
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.kasplexInfoTitle)
        .task {
            await viewModel.fetchKasplexInfo()
        }
    }
}

#Preview {
    NavigationView {
        KasplexInfoView(viewModel: .init(networkService: MockNetworkService()))
    }
}
