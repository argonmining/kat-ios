import SwiftUI

struct KatScanView: View {

    @State var viewModel: KatScanViewModel

    var body: some View {
        ScrollView {
            if viewModel.tokens != nil {
                LazyVStack(spacing: Spacing.padding_2) {
                    ForEach(viewModel.filteredTokens(), id: \.self) { token in
                        TokenListItemView(tokenInfo: token)
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
        .searchable(text: $viewModel.searchText, prompt: "Search tokens")
        .background(Color.surfaceBackground.ignoresSafeArea())
        .task {
            await viewModel.fetchTokens()
        }
    }
}

#Preview {
    KatScanView(viewModel: .init(networkService: MockNetworkService()))
}
