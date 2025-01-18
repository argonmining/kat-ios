import SwiftUI

struct KatScanView: View {

    @State var viewModel: KatScanViewModel

    var body: some View {
        Group {
            if viewModel.isEmpty {
                VStack {
                    Spacer()
                    EmptyStateDS(text: Localization.emptyTokensText)
                        .padding(.horizontal, Spacing.padding_10)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    if viewModel.tokens != nil {
                        LazyVStack(spacing: Spacing.padding_2) {
                            ForEach(viewModel.filteredTokens, id: \.self) { token in
                                TokenListItemView(tokenInfo: token)
                                    .onTapGesture {
                                        viewModel.onItemTap(item: token)
                                    }
                            }
                        }
                        .padding(Spacing.padding_2)
                        .sheet(isPresented: $viewModel.showDetails) {
                            if viewModel.selectedTokenViewModel != nil {
                                TokenDetailsView(viewModel: viewModel.selectedTokenViewModel!)
                                    .presentationDetents([.large])
                                    .presentationDragIndicator(.visible)
                            } else {
                                EmptyView()
                            }
                        }
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
            }
        }
        .navigationTitle(Localization.tabScan)
        .sheet(isPresented: $viewModel.showFilter) {
            TokensFilterView(filterState: $viewModel.filterState)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showFilter.toggle()
                }) {
                    Image(
                        systemName: viewModel.isFiltering
                        ? "line.3.horizontal.decrease.circle.fill"
                        : "line.3.horizontal.decrease.circle"
                    )
                    .fontWeight(.medium)
                }
            }
        }
        .searchable(
            text: $viewModel.searchText,
            prompt: Localization.searchTokensPlaceholder
        )
        .background(Color.surfaceBackground.ignoresSafeArea())
        .task {
            await viewModel.fetchTokens()
        }
        .onChange(of: viewModel.filterState) { oldValue, newValue in
            guard oldValue != newValue else { return }
            viewModel.onFilterStateChange()
        }
        .onChange(of: viewModel.searchText) {
            viewModel.filterTokens()
        }
    }
}

#Preview {
    NavigationView {
        KatScanView(viewModel: .init(networkService: MockNetworkService()))
    }
}
