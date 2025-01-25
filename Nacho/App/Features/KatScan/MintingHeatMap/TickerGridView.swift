import SwiftUI

struct TickerGridView: View {

    @State var viewModel: TickerGridViewModel

    var body: some View {
        let columns = Array(
            repeating: GridItem(
                .flexible(),
                spacing: Spacing.padding_0_5
            ),
            count: 3
        )
        ScrollView {
            VStack {
                if viewModel.showMap {
                    if viewModel.tickers != nil {
                        LazyVGrid(columns: columns, spacing: Spacing.padding_0_5) {
                            ForEach(Array(viewModel.tickers!.enumerated()), id: \.offset) { index, ticker in
                                // Define minimum and maximum heights
                                let minHeight: CGFloat = 30     // Minimum cell height
                                let maxHeight: CGFloat = 100   // Maximum cell height
                                
                                // Calculate proportional height
                                let normalizedMint = ticker.mintTotal / maxMints // Normalize mintTotal (0.0 to 1.0)
                                let cellHeight = minHeight + (CGFloat(normalizedMint) * (maxHeight - minHeight))
                                
                                VStack(spacing: .zero) {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Text(ticker.tick)
                                                .typography(.body1, color: .textOnSolid)
                                            Text(Formatter.formatToNumber(value: ticker.mintTotal))
                                                .typography(.caption2, color: .textOnSolid)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: cellHeight) // Apply the calculated height
                                    Spacer()
                                }
                                .background(interpolatedColor(for: index))
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    viewModel.onTickerSelected(tick: ticker.tick)
                                }
                            }
                        }
                    } else {
                        LazyVGrid(columns: columns, spacing: Spacing.padding_0_5) {
                            ForEach(0...19, id: \.self) { _ in
                                HStack {
                                    Color.solidSuccess.frame(height: 80)
                                        .shimmer(isActive: true)
                                }
                            }
                        }
                    }
                } else {
                    HStack {
                        EmptyStateDS(text: Localization.emptyViewText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, Spacing.padding_10)
                }
            }
            .padding(Spacing.padding_2)
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.mintHeatmapTitle)
        .task {
            await viewModel.fetchMintMap()
        }
    }

    private var maxMints: Double {
        viewModel.tickers!.map { $0.mintTotal }.max() ?? 1
    }

    private func interpolatedColor(for index: Int) -> Color {
        let fraction = Double(index) / Double(viewModel.tickers!.count - 1)

        let startUIColor = UIColor(Color.solidSuccess)
        let endUIColor = UIColor(Color.solidDanger)

        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        
        startUIColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endUIColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)

        let r = startRed + fraction * (endRed - startRed)
        let g = startGreen + fraction * (endGreen - startGreen)
        let b = startBlue + fraction * (endBlue - startBlue)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}

#Preview {
    NavigationView {
        TickerGridView(
            viewModel: .init(
                networkService: MockNetworkService(),
                onTickerSelected: { _ in },
                onTickersLoaded: {_ in }
            )
        )
    }
}
