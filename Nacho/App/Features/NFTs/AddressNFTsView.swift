import SwiftUI

struct AddressNFTsView: View {
    
    let address: String
    let nfts: [NFTData]
    
    var body: some View {
        Group {
            TabView {
                ForEach(nfts, id: \.self) { nft in
                    VStack(spacing: Spacing.padding_1) {
                        Spacer()
                        NFTImage(index: nft.image)
                            .frame(width: 180)
                        Text(nft.name)
                            .typography(.headline3)
                        VStack(alignment: .leading) {
                            let columns = Array(
                                repeating: GridItem(
                                    .flexible(),
                                    spacing: Spacing.padding_1
                                ),
                                count: 2
                            )
                            LazyVGrid(columns: columns, spacing: Spacing.padding_1) {
                                ForEach(nft.rarity.traitBreakdown, id: \.self) { attribute in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(attribute.traitType)
                                                .typography(.subtitle, color: .textSecondary)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                        }
                                        HStack {
                                            Text(attribute.value)
                                                .typography(.body2)
                                                .multilineTextAlignment(.leading)
                                            Text(Formatter.formatPercentage(attribute.percentage))
                                                .typography(.body2, color: .textSecondary)
                                            Spacer()
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            Divider()
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Rarity Rank")
                                            .typography(.subtitle, color: .textSecondary)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(nft.rarity.rank)")
                                            .typography(.subtitle)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Rarity Tier")
                                            .typography(.subtitle, color: .textSecondary)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(nft.rarity.rarityTier)
                                            .typography(.subtitle)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(Spacing.padding_2)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.radius_3)
                                .fill(Material.regular.opacity(0.9))
                        )
                        .padding(.horizontal, Spacing.padding_6)
                        Spacer()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(address.trimmedInMiddle(toLength: 12, shiftStartBy: 6))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func tokenItem(token: AddressTokenInfoKasFyiDTO) -> some View {
        VStack {
            HStack {
                TokenImage(token.ticker)
                VStack(alignment: .leading, spacing: Spacing.padding_0_2_5) {
                    Text(token.ticker)
                        .typography(.body1)
                    Text(Formatter.formatToNumber(token.calculatedBalance))
                        .typography(.caption)
                    
                }
                Spacer()
                Text(Formatter.formatToUSD(token.calculatedBalance * (token.price?.priceInUsd ?? 0.0)))
                    .typography(.numeric4)
            }
        }
    }
}

#Preview {
    NavigationView {
        AddressNFTsView(
            address: "kaspa:qyptk9cfan6nfg60nhdrtwe4n09j09lzxkjxkql7p5ueyr9l7spt4rgmwg34m5a",
            nfts: [
                .init(
                    name: "NACHO #1",
                    image: "/NACHO/1",
                    edition: 1,
                    rarity: .init(
                        rarityScore: 99,
                        rarityMetrics: .init(statisticalRarity: 1, traitRarity: 1, weightedAverage: 1),
                        isSpecial: false,
                        rarityTier: "Something",
                        rank: 1,
                        traitBreakdown: []
                    )
                ),
                .init(
                    name: "NACHO #1",
                    image: "/NACHO/2",
                    edition: 2,
                    rarity: .init(
                        rarityScore: 99,
                        rarityMetrics: .init(statisticalRarity: 1, traitRarity: 1, weightedAverage: 1),
                        isSpecial: false,
                        rarityTier: "Something",
                        rank: 1,
                        traitBreakdown: []
                    )
                )
            ]
        )
    }
}
