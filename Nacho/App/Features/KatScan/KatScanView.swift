import SwiftUI

struct KatScanView: View {

    @State var viewModel: KatScanViewModel

    var body: some View {
        ScrollView {
            if viewModel.tokens != nil {
                LazyVStack(spacing: Spacing.padding_2) {
                    ForEach(viewModel.filteredTokens(), id: \.self) { token in
                        TokenListItemView(tokenInfo: token)
                            .onTapGesture {
                                viewModel.onItemTap(item: token)
                            }
                    }
                }
                .padding(Spacing.padding_2)
            } else {
                VStack(spacing: Spacing.padding_2) {
                    TokenListItemPlaceholderView()
                    TokenListItemPlaceholderView()
                    TokenListItemPlaceholderView()
                    TokenListItemPlaceholderView()
                }
                .padding(Spacing.padding_2)
            }
        }
        .navigationTitle(Localization.tabScan)
        .searchable(
            text: $viewModel.searchText,
            prompt: Localization.searchTokensPlaceholder
        )
        .background(Color.surfaceBackground.ignoresSafeArea())
        .task {
            await viewModel.fetchTokens()
        }
        .sheet(isPresented: $viewModel.showDetails) {
            if viewModel.selectedTokenViewModel != nil {
                TokenDetailsView(viewModel: viewModel.selectedTokenViewModel!)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    KatScanView(viewModel: .init(networkService: MockNetworkService()))
}
