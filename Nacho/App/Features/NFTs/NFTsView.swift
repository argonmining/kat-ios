import SwiftUI
import Vortex

struct NFTsView: View {

    @State var viewModel: NFTsViewModel

    @State private var selectedNFT: NFTInfoModel? = nil
    @State private var isDetailViewVisible: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    collectionHeader
                        .padding(.vertical, Spacing.padding_1)
                    collectionWidget
                    nftGrid
                        .padding(.vertical, Spacing.padding_1)
                }
                .padding(Spacing.padding_2)
                .blur(radius: isDetailViewVisible ? 10 : 0)
            }
            .navigationTitle(Localization.nftsTitle)
            .background(Color.surfaceBackground.ignoresSafeArea())
            .task {
                await viewModel.fetchNachoCollection()
                await viewModel.batchFetchNFTs()
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search for NFT Number"
            )
            .onChange(of: viewModel.searchText) {
                viewModel.filterNFTs()
            }

            // Detail View
            if let selectedNFT = selectedNFT, isDetailViewVisible {
                NFTDetailView(
                    nft: selectedNFT,
                    isVisible: $isDetailViewVisible,
                    namespace: namespace
                ) {
                    self.selectedNFT = nil
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.showGame.toggle()
                }) {
                    Image(systemName: "gamecontroller.fill")
                }
                .sheet(isPresented: $viewModel.showGame) {
                    if viewModel.memoryGameViewModel != nil {
                        NavigationView {
                            MemoryGameView(viewModel: viewModel.memoryGameViewModel!)
                        }
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                    } else {
                        EmptyView()
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.sortNFTs()
                }) {
                    Image(
                        systemName: viewModel.isSortingSelected
                        ? "arrow.up.arrow.down.circle.fill"
                        : "arrow.up.arrow.down.circle"
                    )
                }
            }
        }
        .onDisappear {
            selectedNFT = nil
            isDetailViewVisible = false
        }
    }
    
    @ViewBuilder
    private var nftGrid: some View {
        if viewModel.isNFTsLoading {
            let columns = Array(
                repeating: GridItem(
                    .flexible(),
                    spacing: Spacing.padding_1
                ),
                count: 3
            )
            LazyVGrid(columns: columns, spacing: Spacing.padding_1) {
                ForEach(1...9, id: \.self) { index in
                    ZStack {
                        Color.surfaceForeground
                        Image(systemName: "photo")
                            .foregroundStyle(Color.textSecondary)
                    }
                    .aspectRatio(5 / 6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
                    .shimmer(isActive: true)
                }
            }
        } else {
            let columns = Array(
                repeating: GridItem(
                    .flexible(),
                    spacing: Spacing.padding_1
                ),
                count: 3
            )
            LazyVGrid(columns: columns, spacing: Spacing.padding_1) {
                ForEach(Array(viewModel.filteredNFTs.enumerated()), id: \.offset) { _, nft in
                    NFTImage(index: nft.image, isCache: true)
                        .matchedGeometryEffect(id: nft.image, in: namespace)
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedNFT = nft
                                isDetailViewVisible = true
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private var collectionHeader: some View {
        if let collectionInfo = viewModel.collectionInfo {
            HStack(spacing: Spacing.padding_1_5) {
                Text(collectionInfo.tick)
                    .typography(.headline3, color: .textAccent)
                Spacer()
                PillDS(
                    text: collectionInfo.state,
                    style: .large,
                    color: collectionInfo.state == "deployed"
                    ? .solidSuccess
                    : .solidInfo
                )
            }
        } else if viewModel.isCollectionLoading {
            HStack(spacing: Spacing.padding_1_5) {
                Text("TICKER")
                    .typography(.headline3, color: .textAccent)
                    .shimmer(isActive: true)
                Spacer()
                PillDS(text: "state", style: .large, color: .solidSuccess)
                    .shimmer(isActive: true)
            }
        } else {
            EmptyStateDS(text: Localization.emptyViewText)
                .padding(.top, Spacing.padding_10)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    @ViewBuilder
    private var collectionWidget: some View {
        if let collectionInfo = viewModel.collectionInfo {
            WidgetDS {
                VStack(spacing: .zero) {
                    HStack {
                        Text(Localization.widgetSupply)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    HStack {
                        Text("\(Formatter.formatToNumber(Double(collectionInfo.minted))) / \(Formatter.formatToNumber(Double(collectionInfo.max)))")
                            .typography(.numeric3)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_1)
                    .padding(.bottom, Spacing.padding_2)
                    
                    HStack {
                        Text(Localization.premintedText)
                            .typography(.headline3, color: .textSecondary)
                        Spacer()
                    }
                    HStack {
                        Text("\(Formatter.formatToNumber(Double(collectionInfo.premint)))")
                            .typography(.numeric3)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_1)
                }
            }
        } else if viewModel.isCollectionLoading {
            WidgetDS {
                VStack(spacing: .zero) {
                    HStack {
                        Text(Localization.widgetSupply)
                            .typography(.headline3, color: .textSecondary)
                            .shimmer(isActive: true)
                        Spacer()
                    }
                    HStack {
                        Text("99999/999999")
                            .typography(.numeric3)
                            .lineLimit(1)
                            .shimmer(isActive: true)
                        Spacer()
                    }
                    .padding(.top, Spacing.padding_1)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NFTsView(viewModel: NFTsViewModel(
            networkService: MockNetworkService(),
            dataProvider: MockDataProvider())
        )
    }
}
